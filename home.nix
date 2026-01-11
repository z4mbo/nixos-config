{ config, pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # Add user packages here
  ];

  # Add home-manager configurations here
}