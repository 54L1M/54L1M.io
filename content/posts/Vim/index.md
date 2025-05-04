---
tags:
  - vim
  - neovim
  - cheatsheet
  - productivity
  - text-editors
author: Salim
categories:
  - Guides
cover:
  alt: vim welcome screen
  hidden: false
  hiddenInList: false
  hiddenInSingle: false
  image: vim.png
  relative: true
  responsiveImages: true
date: 2025-01-30
summary: A quick reference guide for navigating and using Vim effectively.
title: Vim Navigation and Useful Commands Cheatsheet
---

## 📝 Introduction

This post is primarily for my own use, containing Vim commands that I frequently use or am trying to learn and remember. It focuses on essential motions and navigation techniques to improve efficiency.

> **Note:** This post changes and updates frequently.

---

## 🏠 Basics

Basic commands to get started with Vim.

- `i` → Insert mode
- `ESC` → Exit insert mode
- `:w` → Save file
- `:q` → Quit
- `:wq` or `ZZ` → Save and quit
- `:q!` → Quit without saving

## 🔄 Moving Around

Essential motions for navigating within a file efficiently.

- `h` → Left
- `j` → Down
- `k` → Up
- `l` → Right
- `0` → Beginning of line
- `^` → First non-blank character of line
- `$` → End of line
- `w` → Next word
- `b` → Previous word
- `e` → End of word
- `gg` → Go to start of file
- `G` → Go to end of file
- `5G` → Go to line 5
- `Ctrl-d` → Move down half a screen
- `Ctrl-u` → Move up half a screen
- `Ctrl-f` → Move forward one full screen
- `Ctrl-b` → Move backward one full screen

## 🔍 Searching and Replacing

Commands to search within a file and replace text efficiently.

- `/pattern` → Search forward
- `?pattern` → Search backward
- `n` → Repeat last search forward
- `N` → Repeat last search backward
- `:%s/old/new/g` → Replace all `old` with `new`
- `:.,+3s/old/new/g` → Replace in current and next 3 lines

## 📂 Working with Files

File management commands to open, navigate, and switch between files efficiently.

- `:e filename` → Open file
- `:tabe filename` → Open in a new tab
- `:sp filename` → Open in a horizontal split
- `:vsp filename` → Open in a vertical split
- `:ls` → List open buffers
- `:bnext` or `:bn` → Next buffer
- `:bprev` or `:bp` → Previous buffer
- `:bd` → Delete buffer

## 📝 Editing

Essential editing commands for modifying text quickly.

- `x` → Delete character under cursor
- `dd` → Delete (cut) current line
- `yy` → Copy current line
- `p` → Paste
- `u` → Undo
- `Ctrl-r` → Redo
- `V` → Visual line selection
- `v` → Visual character selection
- `y` → Yank (copy)
- `d` → Delete (cut)
- `c` → Change (delete and enter insert mode)

## 🎯 Marks and Jumps

Marks allow you to bookmark positions in your file and jump between them easily.

- ` ` → Jump back to last cursor position
- `''` → Jump back to last line
- `:marks` → Show marks
- `mX` → Mark position with `X`
- `'X` → Jump to mark `X`

## ⌨️ Macros

Macros allow you to record and replay sequences of commands, helping with repetitive tasks.

- `qX` → Start recording macro `X`
- `q` → Stop recording
- `@X` → Run macro `X`
- `@@` → Run last macro

## 🚀 Miscellaneous

Various useful commands for enhancing workflow.

- `:noh` → Remove search highlight
- `:set number` → Show line numbers
- `:set relativenumber` → Show relative line numbers
- `:set ignorecase` → Case-insensitive search
- `:set smartcase` → Case-sensitive when uppercase is used
- `Ctrl-g` → Show file info

---

📌 **Tip:** Mastering these commands will make you lightning-fast in Vim!

Let me know if you'd like any additions or modifications! 🚀
