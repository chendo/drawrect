module Motion; module Project;
  class OSXConfig < XcodeConfig
    def main_cpp_file_txt(spec_objs)
      main_txt = <<EOS
#import <AppKit/AppKit.h>

extern "C" {
    void rb_define_global_const(const char *, void *);
    void rb_rb2oc_exc_handler(void);
    void rb_exit(int);
    void RubyMotionInit(int argc, char **argv);
EOS
      if spec_mode
        spec_objs.each do |_, init_func|
          main_txt << "void #{init_func}(void *, void *);\n"
        end
      end
      main_txt << <<EOS
}
EOS
      if spec_mode
        main_txt << <<EOS
@interface SpecLauncher : NSObject
@end

@implementation SpecLauncher

- (void)runSpecs
{
EOS
        spec_objs.each do |_, init_func|
          main_txt << "#{init_func}(self, 0);\n"
        end
        main_txt << <<EOS
        [NSClassFromString(@\"Bacon\") performSelector:@selector(run)];
}

- (void)appLaunched:(NSNotification *)notification
{
    [self runSpecs];
}

@end
EOS
      end

      main_txt << <<EOS
int
main(int argc, char **argv)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
EOS
    if ENV['ARR_CYCLES_DISABLE']
      main_txt << <<EOS
    setenv("ARR_CYCLES_DISABLE", "1", true);
EOS
    end
    main_txt << <<EOS
    RubyMotionInit(argc, argv);
EOS
    if spec_mode
      main_txt << "SpecLauncher *specLauncher = [[SpecLauncher alloc] init];\n"
      main_txt << "[[NSNotificationCenter defaultCenter] addObserver:specLauncher selector:@selector(appLaunched:) name:NSApplicationDidFinishLaunchingNotification object:nil];\n"
    end
    main_txt << <<EOS

    [[NSClassFromString(@"#{delegate_class}") new] main];

    [pool release];
    rb_exit(0);
    return 0;
}
EOS
    end
  end
end; end
