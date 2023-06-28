{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = inputs: {
    packages =
      builtins.mapAttrs (system: pkgs: {
        default =
          pkgs.runCommand "custom-bar" {
            outputHash = pkgs.lib.fakeSha256;
            outputHashAlgo = "sha256";
            builtInputs = with pkgs; [ cacert ] ;
          } ''
              # file transfer
            printf "%b\n" "@nix {\"action\":\"start\",\"level\":1,\"id\":12,\"fields\":[],\"type\":101,\"text\":\"fake data: star wars progress\"}"
            while read -r line; do
              line=''${line//[^[:print:]]/}
              line=''${line##[H}
              printf "%b\n" "@nix {\"action\":\"msg\",\"level\":1,\"msg\":\"$line\"}"
              if [ "$RANDOM" -lt 500 ]; then
                printf "%b\n" "@nix {\"action\":\"result\",\"level\":1,\"id\":12,\"fields\":[$(( $RANDOM * 5000)),$(( $RANDOM * 5000)) ,$(( $RANDOM * 5000)),$(( $RANDOM * 1024 * 1024))],\"type\":105}"
              fi

            done < <({ sleep 1; printf "%s\r" "starwars" ; sleep 40 ; } | ${pkgs.inetutils}/bin/telnet telehack.com) | tr -d '\b\r'
          '';
      })
      inputs.nixpkgs.legacyPackages;
  };
}
