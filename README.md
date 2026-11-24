# The sea life V1.0

基于 **7-Zip 26.06**（上游程序版本）与 **Dark7zip** 的 Windows 定制发行版：12 种压缩格式使用 Zabriskije 绘制的 Keka 风格图标，保留深色主题与 .iso 装载能力。

> 这是非官方定制发行版，不是 7-Zip 官方产品，也未获得 Igor Pavlov 背书。
>
> **版本说明**：`V1.0` 是本定制发行版的版本号；`7-Zip 26.06` 只是它所基于的上游 7-Zip 版本，两者不是一回事。

## 包含什么

- 7-Zip 26.06 原版程序文件（`7zFM.exe` / `7zG.exe` / `7z.exe` / `7z.dll` 等）
- Dark7zip 提供的深色模式及 `7zDark.ini`
- `Icons\` 下 12 个 Keka 风格图标：7z / zip / rar / tar / gz / bz2 / xz / cab / iso / tgz / tbz2 / txz
- `一键关联.bat` / `取消关联.bat`，以及 `scripts\` 下的两个 .ps1 脚本
- 完整许可证与署名（见 `LICENSES.md`、`licenses\`）

## 更换主题（Dark7-Zip）

Dark7-Zip 在原生 7-Zip 上加入了完整主题能力，有两种改法：

### 方式一：图形界面（最快）

打开 `7zFM.exe`，进入 **工具 → 选项 → 设置 → 颜色模式**，可切换 **深色 / 浅色 / 跟随系统**。

### 方式二：编辑 `7zDark.ini`（精细定制）

程序目录下的 `7zDark.ini` 可以自定义配色与窗口观感。**它的优先级高于界面设置**——只要文件存在，界面里的颜色模式选项就会被它接管。改完保存后重启 `7zFM.exe` 生效；想交还界面控制，把 `7zDark.ini` 改名或删掉即可。

常用配置项：

| 位置 | 键 | 说明 |
| --- | --- | --- |
| `[main]` | `mode` | 0 浅色 / 1 深色 / 2 跟随系统（当前）/ 3 经典 / 4 跟随系统+经典 |
| `[dark]` | `tone` | 深色基调：0 黑（当前）/ 1 红 / 2 绿 / 3 蓝 / 4 紫 / 5 青 / 6 橄榄 |
| `[dark]` / `[light]` | `mica` | Win11 材质：0 自动 / 1 关闭 / 2 Mica / 3 亚克力 / 4 Mica Alt（当前深色用 4） |
| `[dark]` / `[light]` | `roundCorner`、`borderColor`、`colorizeTitleBar` | 圆角、窗口边框色、标题栏是否跟随配色 |
| `[dark.colors]` / `[light.colors]` | `background`、`text`、`edge`、`highlight` 等 | 控件背景、文字、边框、高亮色，格式为 `RRGGBB` |
| `[dark.colors.view]` / `[light.colors.view]` | `backgroundView`、`textView`、`gridlines` 等 | 列表/树视图的背景、文字、网格线、表头 |

> 主题效果依赖系统：深色模式需要 Windows 10 19044+ 或 Windows 11；Mica / 亚克力、圆角等效果需要 Windows 11 22H2+。

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
