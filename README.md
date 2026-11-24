# The Sea Life

基于 **7-Zip 26.06** 与 **Dark7zip** 的 Windows 定制发行版：12 种压缩格式使用 Zabriskije 绘制的 Keka 风格图标，保留深色主题与 .iso 装载能力。

> 这是非官方定制发行版，不是 7-Zip 官方产品，也未获得 Igor Pavlov 背书。

## 包含什么

- 7-Zip 26.06 原版程序文件（`7zFM.exe` / `7zG.exe` / `7z.exe` / `7z.dll` 等）
- Dark7zip 提供的深色模式及 `7zDark.ini`
- `Icons\` 下 12 个 Keka 风格图标：7z / zip / rar / tar / gz / bz2 / xz / cab / iso / tgz / tbz2 / txz
- `一键关联.bat` / `取消关联.bat`，以及 `scripts\` 下的两个 .ps1 脚本
- 完整许可证与署名（见 `LICENSES.md`、`licenses\`）

## 便携版怎么用

1. 解压到**固定目录**（不要频繁移动；注册表里是绝对路径）
2. 双击 `一键关联.bat`
3. 随便找一个 `.rar` 看图标是否变成 Keka 风格
4. 想还原：双击 `取消关联.bat`

**注意**：Windows 不会在解压 zip 时自动执行任何程序（安全机制），所以便携版需要你手动双击一次。安装包则可以在安装过程中自动完成。

## 安装包（需要 Inno Setup 编译）

`installer/setup.iss` 是安装包脚本。安装向导里可以选择安装目录，安装结束时自动调用关联脚本；卸载时调用还原脚本。

## 已知限制

1. **默认应用无法程序化设置**。Windows 禁止程序改写 `UserChoice`。脚本能注册图标、右键菜单和"打开方式"，但对已经存在 UserChoice 的扩展名（如 `.zip`），双击默认程序可能仍需在系统设置里确认一次。
2. **移动程序目录会使图标失效**。注册表指向绝对路径；搬走后请重新运行关联脚本。
3. **老文件夹可能仍显示旧图标**。文件夹图标会合成里面第一个文件的图标，并缓存在 `thumbcache_*.db`。换图标后删掉 `%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db` 并重启资源管理器即可。
4. `.iso` 的默认动词是 `mount`，双击仍走 Windows 装载，图标用 Keka 风格。

## 构建

`build\Build-Portable.ps1` 从一份已有的 Dark7zip 目录生成便携 zip。

## 许可与署名

详见 `LICENSES.md`。7-Zip（LGPL-2.1+）、Dark7zip（MIT / MPL-2.0）、图标（CC BY-NC-SA 4.0）各自的许可和署名都必须保留。
