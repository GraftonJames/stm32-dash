FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    arm-none-eabi-gcc \
    arm-none-eabi-newlib \
    cmake \
    make \
    git \
    openocd \
    neovim \
    llvm \
    clang \
    bear \
    python-pip

# Optional: Install a plugin manager like vim-plug
RUN curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Start OCD server for gdb debugging
RUN openocd -f interface/stlink.cfg -f target

WORKDIR /home/dev/project
