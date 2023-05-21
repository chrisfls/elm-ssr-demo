{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = with pkgs; [
    deno
    nodejs-16_x # needed by elm-language-server
    nodePackages.pnpm # needed for elm build/devserver
  ];
}