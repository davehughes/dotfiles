{ pkgs, lib, ... }:

let
  dave-cli = with pkgs.python312Packages; buildPythonPackage {
    name = "dave-cli";
    version = "v0.1.2";
    format = "pyproject";
    src = pkgs.fetchFromGitHub {
      owner = "davehughes";
      repo = "dave-cli";
      rev = "v0.1.2";
      sha256 = "DCe0YqlrisT5ti/l3OTnI8EWZYSj35m+s/obdSahUSI=";
    };

    propagatedBuildInputs = [ setuptools tabulate pyyaml ];
  };

  pyprojroot = with pkgs.python312Packages; buildPythonPackage {
    name = "pyprojroot";
    version = "0.0.1";
    format = "pyproject";
    src = pkgs.fetchFromGitHub {
      owner = "chendaniely";
      repo = "pyprojroot";
      rev = "329e2cd6ed9f357aaa9e2785d1d7990a7a6b1100";
      sha256 = "GHNOdAbY7ni4NXCnLW5xAsACJOCo6xySY2JHAHAe0bc=";
    };

    propagatedBuildInputs = [ setuptools typing-extensions ];
  };

  autoimport = with pkgs.python312Packages; buildPythonPackage {
    name = "autoimport";
    version = "1.5.0";
    format = "pyproject";
    src = pkgs.fetchFromGitHub {
      owner = "lyz-code";
      repo = "autoimport";
      rev = "1.5.0";
      sha256 = "i2MPw0pWTLNLT4cTTXClQ+u+pXQcnsy6wwm4knEVIos=";
    };

    propagatedBuildInputs = [ pdm-backend autoflake sh maison xdg pyprojroot ];
  };
in
{
  inherit dave-cli;
  inherit autoimport;
}
