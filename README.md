# elm-ssr-demo

Architecture:

- [GraphQL API](https://graphql.org/) in [Elixir](https://elixir-lang.org/)
- Frontend in [Elm](https://elm-lang.org/)
- Frontend server in [Deno](https://deno.com/)

## Does it work?

Yes.

## Setup

Nothing too crazy, assuming archlinux:

1. Setup [Nix](https://wiki.archlinux.org/title/Nix)
2. Setup [direnv](https://direnv.net/)
3. Setup [docker](https://wiki.archlinux.org/title/docker) and [docker-compose](https://archlinux.org/packages/?name=docker-compose):
```bash
pacman -Syu docker docker-compose 
sudo usermod -aG docker $(whoami)
sudo systemctl start docker
sudo systemctl enable docker
```
4. Run postgres with `docker-compose up -d`;
5. Run backend
    - Install dependencies with `mix deps.get`
    - Run backend with `mix phx.server`
6. Run frontend with `deno task dev`.
    - To update schemas run `pnpm install` and `deno task api`.

## Notes

This doesn't do any hydration, so it diffs the whole view after loading. But this is not that bad as it does reuse the model, avoiding useless reloads.

Rendering on the server is done thanks to [elm-html-string](https://github.com/zwilias/elm-html-string) so this doesn't support [elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) and components available in [elm packages](https://package.elm-lang.org/).

This could be fixed abusing a hack from [elm-test](https://github.com/elm-explorations/test/blob/master/src/Elm/Kernel/HtmlAsJson.js), but I didn't want to redo this hack here.

I didn't do any routing here, but it can be done easily in the same way [elm-spa-example](https://github.com/rtfeldman/elm-spa-example/blob/master/src/Route.elm) does.

For a solution more compatible with available packages see [elm-pages](https://github.com/dillonkearns/elm-pages).
