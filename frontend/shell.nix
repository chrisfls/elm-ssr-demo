{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = with pkgs; [
    deno
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-live
    elmPackages.elm-test
    nodejs-16_x # needed by elm-language-server
  ];
}