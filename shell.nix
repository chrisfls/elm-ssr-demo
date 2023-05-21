{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = with pkgs; [
    deno
    elixir_1_14
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-language-server
    nodejs-16_x # needed by elm-language-server
  ];
}