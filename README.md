# Kill Gun

## 项目概述 (Project Overview)

Kill Gun 是一款使用 Godot 引擎开发的 2D 自上而下射击游戏。玩家控制角色在地图上移动，使用武器消灭敌人，通过不同关卡进行游戏。

## 项目架构 (Project Architecture)

### 核心系统 (Core Systems)

- **Game.gd**: 全局游戏管理器，处理伤害计算、UI显示和相机效果
- **PlayerManager.gd**: 管理玩家状态、武器切换和死亡检测
- **EnemyManager.gd**: 管理敌人生成和追踪
- **LevelManager.gd**: 管理关卡加载和切换

### 主要场景 (Main Scenes)

- **Main.tscn**: 主场景，游戏入口点
- **Player.tscn**: 玩家角色，处理移动和动画
- **BaseWeapon.tscn**: 基础武器系统
- **BaseBullet.tscn**: 子弹物理和碰撞
- **BaseEnemy.tscn**: 敌人AI和寻路系统

### 数据结构 (Data Structures)

- **PlayerData.gd**: 玩家属性数据
- **EnemyData.gd**: 敌人属性数据
- **LevelData.gd**: 关卡配置数据

### UI 系统 (UI System)

- **MainUI.tscn**: 主界面
- **HUD.tscn**: 游戏中界面，显示生命值、弹药和关卡信息
- **HitLabel.tscn**: 伤害数字显示效果

## 已实现功能 (Implemented Features)

- 玩家移动与动画系统
- 武器射击和换弹机制
- 敌人AI和寻路
- 关卡加载与敌人生成
- 伤害计算系统
- 相机震动效果
- HUD显示（生命值、弹药、武器信息、关卡）

## 潜在问题 (Potential Issues)

1. **敌人寻路问题**: 在 `base_enemy.gd` 中使用了 NavigationServer2D，但可能存在路径计算未完成就移动的问题。

2. **子弹销毁机制不完善**: 在 `base_bullet.gd` 中，子弹销毁逻辑基于帧计数和时间计数混合使用，可能导致子弹不正确销毁。

3. **缺少错误处理**: 多处代码缺少错误检查，如在 `LevelManager.gd` 中没有处理关卡数据加载失败情况。

4. **性能优化不足**: 敌人生成大量时可能导致性能问题，缺少对象池或LOD系统。

5. **缺少状态管理**: 玩家和敌人状态管理比较简单，可能在复杂交互时出现问题。

## 未实现功能 (Unimplemented Features)

1. **多种武器系统**: 虽有武器切换功能，但仅实现了 Gun2.tscn。

2. **游戏存档与读取**: 目前无游戏进度保存功能。

3. **游戏菜单与设置**: 缺少主菜单、暂停菜单和游戏设置。

4. **敌人种类有限**: 虽有 Ghoul.tscn，但未见其他实现的敌人类型。

5. **升级系统**: 无玩家技能或属性升级系统。

6. **音效与音乐系统**: 部分音效已实现，但缺少背景音乐和完整的音效系统。

7. **视觉特效**: 缺少丰富的视觉效果，如攻击特效、环境效果等。

## 如何运行 (How to Run)

1. 安装 Godot 引擎（推荐版本 4.x）
2. 克隆此仓库
3. 使用 Godot 引擎打开项目
4. 点击运行按钮开始游戏

## 控制方式 (Controls)

- WASD: 角色移动
- 鼠标: 瞄准
- 鼠标左键: 射击
- 空格键: 切换武器（目前仅有一种）

## 扩展建议 (Expansion Suggestions)

1. 完善武器系统，增加更多武器类型
2. 添加更多敌人类型和AI行为
3. 实现升级系统和技能树
4. 添加Boss战和特殊关卡
5. 实现游戏存档功能
6. 添加更多视觉和音效
7. 优化性能，特别是敌人AI和子弹物理 