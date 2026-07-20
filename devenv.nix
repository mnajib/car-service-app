{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  #env.GREET = "devenv";
  env.GREET = "Car Service App Dev Environment";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    php83
    php83Packages.composer
    #phpMyAdmin

    inputs.my-nvim.packages.${pkgs.stdenv.system}.default
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;
  languages.php = {
    enable = true;
    package = pkgs.php83;
  };

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    # Creates an initial database and user automatically on first start

    initialDatabases = [
      { name = "car_service_db"; }
    ];

    #ensureUsers = [
    #  {
    #    name = "app_user";
    #    password = "app_password";
    #    ensurePermissions = {
    #      "car_service_db.*" = "ALL PRIVILEGES";
    #    };
    #  }
    #];

  };

  # Background Processes (App Server & phpMyAdmin Server)
  #processes.serve.exec = "php -S 127.0.0.1:8000 -t public";
  #processes.serve.exec = "php -S 127.0.0.1:8001 -t phpmyadmin";
  #processes = {
    #enable = true;

    #car-app.exec = "php -S 127.0.0.1:8000 -t public";
    #phpmyadmin.exec = "php -S 127.0.0.1:8001 -t phpmyadmin";

    /*
    phpmyadmin.exec = ''
      PMA_DIR=".devenv/phpmyadmin"
      if [ ! -d "$PMA_DIR" ]; then
        echo "Downloading phpMyAdmin..."
        mkdir -p "$PMA_DIR"
        tar -xzf ${pkgs.phpMyAdmin}/share/phpMyAdmin/*.tar.gz -C "$PMA_DIR" --strip-components=1

        # Inject basic config to connect to local MariaDB socket/port without prompts
        cat <<'EOF' > "$PMA_DIR/config.inc.php"
<?php
$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['AllowNoPassword'] = true;
EOF
      fi
      php -S 127.0.0.1:8001 -t "$PMA_DIR"
    '';
    */

  #};

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version # Use packages

    echo "======================================================="
    echo "  1. Start MariaDB:       devenv up"
    echo "  2. App Server (Tab 2):  php -S 127.0.0.1:8000 -t public"
    echo "  3. phpMyAdmin (Tab 3):  php -S 127.0.0.1:8001 -t phpmyadmin"
    echo "======================================================="
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
