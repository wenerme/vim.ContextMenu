

vim.ContextMenu
===============

Add Context menu for vim,It's only a batch file.

Screenshot
-------------

<blockquote class='cmd' style="color:red">
<pre>
Context menu for gvim

1 - Install (use dir G:\minienv\env\vim\vim74)FOUND
2 - Install (use dir G:\minienv\env\vim\vim74\)FOUND
3 - Install (ask VIM dir)
8 - Uninstall
9 - Exit



Choose a task:
</pre>
</blockquote>

Useage
------

```bat
:: Use %CD%
contextmenu_for_vim install_cd
:: Use dir where you put this bat file
contextmenu_for_vim install_dp0
:: Use %1 as dir
contextmenu_for_vim C:\vim
:: Remove in context menu
contextmenu_for_vim uninstall
:: Interactive mode
contextmenu_for_vim
```

TODO
-----

* 添加 选项来控制添加的菜单项
* 添加 快捷键

