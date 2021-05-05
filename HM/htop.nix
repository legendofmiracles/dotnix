{ config, pkgs, ... }:

{
  programs.htop = {
    enable = true;
    detailedCpuTime = true;
    showCpuFrequency = true;
    showCpuUsage = true;
    showProgramPath = false;
    showThreadNames = true;
    meters = {
      left = [ "AllCPUs" "Memory" "Swap" ];
      right = [ "Tasks" "LoadAverage" "Uptime" ];
    };
  };
}
