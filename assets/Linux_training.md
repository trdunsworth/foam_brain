# Linux training notes

The goal for using the notes and documentation is to increase my comfort with the command line and prepare for the Linux+ exam. I think that it will do me better in the long run and I will, eventually, be more productive.

## Neovim

The big 4 that are listed in everyone's discussions are [LazyVim](https://www.lazyvim.org/), [AstroNvim](https://astronvim.com/), [LunarVim](https://www.lunarvim.org/), and [NvChad](https://nvchad.com/). I also know that [Spacemacs](https://www.spacemacs.org/) is something to pay attention to, even if it is an emacs *'clone'*. However, it is good to know about it and invesitgate it later to see if it is useful for my goals. [Kickstart](https://github.com/nvim-lua/kickstart.nvim) isn't a distribution, but a good starting point for possibly building my own configuration over time. That might be something to look into once I refamiliarize myself with the Vim universe. [CyberNvim](https://github.com/pgosar/CyberNvim) is another one to look over. If Spacemacs is interesting, then [Spacenvim](https://liuchengxu.github.io/space-vim/) may be worth looking into. Keep an eye out for [Nvpunk](https://gabmus.org/posts/nvpunk_a_modern_neovim_distribution_with_batteries_included/). Like Kickstart, [MartinLwx's Blog](https://martinlwx.github.io/en/config-neovim-from-scratch/) looks to be another good resource for building a Neovim configuration from scratch. [This](https://alpha2phi.medium.com/learn-neovim-the-practical-way-8818fcf4830f#ce0a) is the best educational resource I think I could find.

This website [Create your own Neovim config from scratch](https://www.youtube.com/watch?v=w7i4amO_zaE) could be an interesting option to build my own specializeed conifguration over time as I learn more and move beyond the distribution tools. Combining this with Kickstart might create a really specialized configuration that addresses my wants and needs pretty solidly.

I've noticed that all of these Neovim distributions, and [Neovim](https://neovim.io/) itself lean heavily on the [Lua programming language](https://www.lua.org/). Obviously, I will have to learn a little bit of it so I can understand what I'm doing and do it more efficiently.

With only a quick glance, [Lazyman](https://lazyman.dev/) appears to be an interesting concept. It allows you to run different Neovim configurations and compare them to each other. That could be useful for understanding how they work and if anything works better with my programming style.

A good list of Neovim plugins can be found [here](https://neovimcraft.com/).

### Neovim and Data Science

I figured, *"What the hell"* and decided to Google Neovim and Data Science to see what comes up. I'm surprised that there were so many entries. I guess I shouldn't be. I think I should look at Neovim and Jupyter notebooks next. This is a good starting point: [Neovim Setups for Data Science](https://medium.com/geekculture/neovim-setups-for-data-science-5ea251e3735f). [Nvim](https://github.com/milanglacier/nvim) is another setup that looks interesting. This is a longer read: [Neovim for Data Science](https://coen.needell.org/post/neovim_for_data_science_1/) it looks like it's worth reading. [Alpha2phi](https://alpha2phi.medium.com/) has a tonne of great material on Neovim. [Neovim PDE for Data Science](https://alpha2phi.medium.com/neovim-pde-for-data-science-e1cc4c82a424) looks to be great work as well. Since I do a lot of work with [quarto](https://quarto.org/), [this](https://quarto.org/docs/get-started/hello/neovim.html) is the starting point to making that work properly.

Since much of any Pyton for data science work is done in a Jupyter or Jupyterlab instance, [alpha2phi's tutorials](https://alpha2phi.medium.com/jupyter-notebook-vim-neovim-c2d67d56d563) will likely be the best starting point to understanding and getting properly setup. However, this is an interesting article about setting up Jupyterlab as a great text editor: [JupyterLab as a Text Editor](https://medium.com/towards-data-science/unlocking-the-potential-of-jupyterlab-discover-the-powerful-text-editor-you-never-knew-you-had-af18bf5bce3f).

## Shell work

In my current distro, I am using Arch with a [fish shell](https://fishshell.com/). I certainly want to gain better familiarity with it. I know that it can run all of the normal shell commands, so I need to understand it better. Everything I was researching last night recommended installing [omf](https://github.com/oh-my-fish/oh-my-fish). I haven't installed it yet. I have used cousins of it in bash and zsh before, but I don't think I ever leveraged it properly. So I want to learn more about it to make better use of it.I also should add [tmux](https://github.com/tmux/tmux/wiki) into the shell. This could be a good addition to make my terminal work as efficient as possible. I am also invesetigating adding plug-ins and possibly AI enhancements to my shell. [Fisher](https://github.com/jorgebucaran/fisher) looks to be the most recommended plug-in manager for fish. I also noticed a plug-in, [fish-ai](https://github.com/Realiserad/fish-ai), that could be useful for AI integration.

[Command Line Productivity with Fish Shell](https://yankeexe.medium.com/command-line-productivity-with-fish-shell-26dd77d7d018) has a lot of interesting commands to use with the shell, after installing omf and fisher.

## Git on the command line

[Atlassian](https://www.atlassian.com/git) has a good Git tutorial and I can learn to use it and [Lazygit](https://github.com/jesseduffield/lazygit) to increase my command line skills. I'm hoping that this [Medium article](https://medium.com/@rasmusfangel/level-up-git-with-lazygit-b5e6c923c5d7) will provide some tutorial support.
