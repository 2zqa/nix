{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "swagger-preview";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "swagger-preview";
    rev = "v${version}";
    hash = "sha256-yYRLgkDBSxIsT70rqsQ3S4IYw2wRImMWX2/C57MuDTY=";
  };

  vendorHash = "sha256-mDWelRnWj6lNsEz7e+aT4y3QY7wrWD9ys9AvkQyYB4s=";

  # The main binary is in cmd/spr
  subPackages = [ "cmd/spr" ];

  meta = {
    description = "Preview swagger with live reload";
    homepage = "https://github.com/skanehira/swagger-preview";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "spr";
  };
}
