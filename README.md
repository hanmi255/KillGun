# Kill Gun

## 项目概述 (Project Overview)

Kill Gun 是一款使用 Godot 引擎开发的 2D 自上而下射击游戏。玩家控制角色在地图上移动，使用武器消灭敌人，通过不同波次的敌人来完成关卡。

## 项目架构 (Project Architecture)

### 核心系统 (Core Systems)

- **Game.gd**: 全局游戏管理器，处理游戏状态、玩家引用和相机效果
- **ServiceLocator.gd**: 服务定位器，提供对各管理器的全局访问
- **EventBus.gd**: 事件总线，负责系统间的消息传递和解耦
- **LevelManager.gd**: 管理关卡加载和切换
- **WeaponManager.gd**: 管理武器切换和装备
- **AudioManager.gd**: 处理游戏中的音频播放
- **EnemySpawner.gd**: 管理敌人生成和波次控制

### 状态机系统 (State Machine System)

- **StateMachine.gd**: 通用状态机框架
- **State.gd**: 基础状态类
- 敌人状态: 包含移动、攻击、受击、死亡和空闲状态
- 玩家状态: 包含死亡状态

### 主要场景 (Main Scenes)

- **Main.tscn**: 主场景，游戏入口点
- **Player.tscn**: 玩家角色，处理移动和动画
- **WeaponBase.tscn**: 基础武器系统
- **BulletBase.tscn**: 子弹物理和碰撞
- **EnemyBase.tscn**: 敌人AI和寻路系统

### 数据模型 (Data Models)

- **PlayerData.gd**: 玩家属性数据
- **EnemyData.gd**: 敌人属性数据
- **LevelData.gd**: 关卡配置数据
- **WeaponData.gd**: 武器配置数据

### UI 系统 (UI System)

- **StartMenu.tscn**: 开始菜单
- **HUD.tscn**: 游戏中界面，显示生命值、弹药和关卡信息
- **DamageLabel.tscn**: 伤害数字显示效果

## 已实现功能 (Implemented Features)

- 玩家移动与动画系统
- 多武器系统，支持切换不同武器
- 武器射击、弹药管理和换弹机制
- 敌人AI和寻路系统
- 关卡波次系统，支持多个关卡配置
- 伤害计算系统，包括暴击机制
- 相机震动效果
- HUD显示（生命值、弹药、武器信息、波次计数）
- 音效系统（射击、换弹、受击音效）

## 潜在问题 (Potential Issues)

1. **敌人寻路问题**: 敌人使用NavigationAgent2D进行寻路，但可能存在路径计算未完成就移动的问题。
2. **子弹销毁机制**: 子弹销毁基于时间计数，需要确保子弹在击中目标或超出生存时间时正确销毁。
3. **错误处理**: 部分代码缺少完善的错误检查，如在资源加载失败时的处理。
4. **性能优化**: 大量敌人同时生成可能导致性能问题，未实现对象池系统。
5. **玩家状态管理**: 玩家状态机目前较为简单，仅实现了死亡状态。

## 未实现功能 (Unimplemented Features)

1. **游戏存档与读取**: 目前无游戏进度保存功能，ServiceLocator中预留了SaveManager接口。
2. **游戏暂停和设置**: 虽有暂停功能框架，但缺少完整的暂停菜单和设置界面。
3. **敌人种类多样性**: 项目结构支持多种敌人（Ghoul、Spitter、Summoner），但需要完善每种敌人的具体实现。
4. **升级系统**: 无玩家技能或属性升级系统。
5. **背景音乐**: 音频系统框架已实现，但缺少背景音乐。
6. **更丰富的视觉特效**: 可以添加更多特效，如环境效果、武器特效等。
7. **游戏结束界面**: 游戏结束时缺乏专门的胜利/失败界面。

## 如何运行 (How to Run)

1. 安装 Godot 引擎（版本 4.x）
2. 克隆此仓库
3. 使用 Godot 引擎打开项目
4. 点击运行按钮开始游戏

## 控制方式 (Controls)

- WASD: 角色移动
- 鼠标: 瞄准
- 鼠标左键: 射击
- 鼠标右键: 手动换弹
- Q/E: 切换武器（如果有多把武器）

## 扩展建议 (Expansion Suggestions)

1. 完善多种敌人类型的实现和AI行为
2. 添加更多武器和弹药类型
3. 实现升级系统和技能树
4. 添加Boss战和特殊关卡
5. 实现游戏存档功能和配置系统
6. 添加背景音乐和更多音效
7. 优化性能，特别是敌人AI和子弹物理
8. 添加联机多人模式
