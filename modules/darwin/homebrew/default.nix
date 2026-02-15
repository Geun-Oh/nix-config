{ ... }:

{
  homebrew = {
    enable = true;

    brews = [
      "zig"
      "hugo"
      "ripgrep"
    ];

    casks = [
      "orbstack"
      "obsidian"
      "raycast"
      "cursor"
      "postman"
      "warp"
      "cloudflare-warp"
      "arc"
      "slack"
      "google-chrome"
    ];

    masApps = {
      "KakaoTalk" = 869223134;
    };
  };
}
