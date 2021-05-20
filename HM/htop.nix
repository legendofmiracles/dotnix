{ config, pkgs, lib, ... }:

{
  programs.htop = {
    enable = true;

    settings = {
      detailed_cpu_time = true;
      hide_kernel_threads = false;
      show_cpu_frequency = true;
      show_cpu_usage = true;
      show_program_path = false;
      show_thread_names = true;
    };
    /* // (with config.lib.htop; leftMeters {
         AllCPUs = modes.Bar;
         Memory = modes.Bar;
         Swap = modes.Bar;
         Zram = modes.Bar;
       })
       // (with config.lib.htop; rightMeters {
         Tasks = modes.Text;
         LoadAverage = modes.Text;
         Uptime = modes.Text;
         Systemd = modes.Text;
       });
    */
  };
}
