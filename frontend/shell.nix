{ pkgs ? import <nixpkgs> { } }:
let
  unstable = import <nixpkgs-unstable> {};
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    unstable.deno
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-test-rs
    elmPackages.elm-review
    nodejs-16_x # needed by elm-language-server
    nodePackages.pnpm # needed by elm-graphql
  ];
}