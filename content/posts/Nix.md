---
title: Why Nix and nix-darwin Are Great for macOS
date: 2024-12-24
tags:
  - nix
  - nix-darwin
  - macOS
  - dev-tools
  - unstable-branch
  - configuration
summary: Learn why Nix and nix-darwin are powerful tools for macOS development and how I use them to streamline my workflow.
categories: Config
---


As a macOS user and developer, finding a robust, flexible, and reproducible way to manage system configurations and development environments has always been a challenge. While macOS is a great platform for development, its native tools can sometimes feel limiting in terms of flexibility, especially when compared to Linux-based systems.

  

This is where **Nix** and **nix-darwin** come in. These tools allow you to manage macOS system configurations and software installations declaratively and reproducibly, ensuring consistency across multiple devices or even between different points in time.

  

**P.S.** You can find my complete configuration on [GitHub](https://github.com/54L1M/shenfiles/tree/master/nix). Feel free to explore and use it!

  

---

  

## Why Nix?

  

### Declarative System Management

  

Nix is a package manager and build system that operates on the principle of **declarative configuration**. Instead of manually installing and configuring software, you describe your desired system state in a configuration file. This makes it easy to reproduce an exact environment across machines.

  

This approach is particularly helpful for developers who need to work on multiple devices or collaborate in teams. With Nix, there’s no need to document a series of manual steps—your configuration file serves as a single source of truth. For example, installing packages or defining environment variables becomes as simple as editing your configuration file.

  

### Reproducibility

  

The primary benefit of Nix’s declarative approach is **reproducibility**. If you describe your system with a configuration file, you can recreate it exactly, no matter where or when. This is a game-changer for maintaining development environments across different machines or even across different points in time.

  

Imagine this scenario: your primary development machine crashes, and you’re left with a blank replacement device. With Nix, you don’t need to manually reinstall software, recreate your custom setups, or remember every tweak you made to the system. Simply apply your configuration file, and your environment is back—exactly as it was before.

  

### Rollbacks and Version Control

  

Another unique feature of Nix is the ability to **rollback** changes. Every change you make to your environment is essentially a new version. If you add or update a package and it breaks something, you can quickly revert to a previously working state. This version-control-like behavior makes experimentation safer, encouraging you to try new tools or configurations without fear of irreparable damage.

  

In practice, this means that even if a package update introduces a bug, your entire system remains stable. Rolling back takes seconds, and you can even toggle between configurations to test different setups.

  

### Flexibility and Customizability

  

One of the reasons Nix is so beloved by developers is its **flexibility**. Every aspect of your system can be customized, from environment variables to the specific versions of software you want to use. Want to test an older version of Python or a nightly build of a cutting-edge tool? Nix makes it easy to isolate these environments without impacting the rest of your system.

  

For macOS users, Nix also bridges the gap between Linux and macOS development, allowing for shared configurations and a more seamless workflow between platforms.

  

---

  

## Why Use Nix on macOS?

  

While macOS is developer-friendly, it doesn’t have the package management sophistication of Linux distributions. Homebrew is a popular choice for macOS package management, but it lacks the declarative, reproducible, and rollback features that Nix offers.

  

With **nix-darwin**, macOS users can enjoy the same declarative system management as NixOS, including:

  

- Managing macOS preferences (e.g., Dock auto-hide, Finder view style).

- Installing macOS applications alongside Unix tools.

- Creating a fully reproducible macOS environment for development.

  

---

  

## What is the Unstable Branch of Nix?

  

The **unstable branch** of Nix, known as `nixpkgs-unstable`, is the cutting-edge version of the Nix package collection. It contains the latest versions of packages and system improvements. By using this branch, you gain access to:

  

- **The Latest Features and Tools**: Cutting-edge tools and libraries are available as soon as they’re introduced.

- **Frequent Updates**: Since the branch is regularly updated, you’ll always have access to the latest versions of your favorite tools.

- **Community Contributions**: Many new packages and features are added to the unstable branch by contributors before they’re integrated into the stable release.

  

### Trade-offs of Using the Unstable Branch

  

While the unstable branch provides the latest updates, it may also introduce occasional bugs or backward compatibility issues. For developers who rely on bleeding-edge tools, these risks are often outweighed by the benefits. However, for production systems or environments where stability is critical, the stable branch might be more appropriate.

  

In my workflow, the unstable branch ensures I have access to the newest versions of development tools, which helps me stay up to date in fast-paced projects.

  

---

  

## Updating and Building with nix-darwin

  

Using **nix-darwin** requires a few simple commands to keep your system updated and apply configuration changes.

  

### Update the Nix Flake Inputs

  

To ensure your flake inputs (like `nixpkgs` and `nix-darwin`) are up to date, use:

  

```bash

nix flake update

```

  

This command updates all dependencies defined in your `flake.nix` file to their latest versions. After updating, you can rebuild your system to apply any changes.

  

### Rebuild the System Configuration

  

Once you’ve updated your flake inputs or made changes to your configuration, you can rebuild your system with:

  

```bash

darwin-rebuild switch --flake .#<hostname>

```

  

Replace `<hostname>` with the name of your configuration, as defined in your `flake.nix`. For example, if your configuration is named `54L1M`, you’d run:

  

```bash

darwin-rebuild switch --flake .#54L1M

```

  

This command applies your configuration changes immediately, including updating installed packages, applying macOS preferences, and restarting necessary services.

  

### Test Changes Safely

  

If you’re testing changes and don’t want to apply them immediately, use the `build` command instead:

  

```bash

darwin-rebuild build --flake .#54L1M

```

  

This creates a build of your configuration without applying it. Once you’re confident in the changes, you can switch to the new configuration.

  

---

  

## My nix-darwin Configuration

  

Below is an excerpt of my **nix-darwin** configuration, which is also available on [GitHub](https://github.com/54L1M/shenfiles/tree/master/nix).

  

### Overview

  

This configuration manages:

- System-level packages like `neovim`, `git`, and `rustup`.

- macOS applications like `Spotify`, `Firefox`, and `Obsidian`.

- macOS preferences like enabling dark mode and configuring the Dock.

  

### Full Configuration

  

```nix

{
  description = "54L1M Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:

    let
      configuration = { pkgs,config, ... }: {

        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [
          alacritty
          neovim
          git
          tmux
          ripgrep
          python313
          ...
        ];
        homebrew = {
          enable = true;
          brews = [
            "mas"
            "hugo"
            ...
          ];
          casks = [
            "firefox"
            ...
          ];
        };
        fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
        ];
        nix.settings.experimental-features = "nix-command flakes";
        programs.zsh.enable = true;
      };
    in
    {
      darwinConfigurations."54L1M " = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
        ];
      };
    };
}
```

  

---

  

## Conclusion

  

Incorporating **Nix** and **nix-darwin** into my workflow has been transformative. The declarative and reproducible nature of Nix ensures that my development environment is consistent, reliable, and easy to manage. Using the **unstable branch** allows me to stay on the cutting edge of technology, which is crucial for my development needs.

  

If you’re a macOS user looking for a powerful alternative to traditional package managers, I highly recommend giving Nix and nix-darwin a try. For more details, feel free to check out my full configuration on [GitHub](https://github.com/54L1M/shenfiles/tree/master/nix).

  

Happy hacking! 🚀