# audio_manager

BGM・SE の再生と音量管理を行う Autoload モジュール。
音量設定は `user://audio_settings.cfg` に自動保存される。

## セットアップ

1. `audio_manager/` を `addons/audio_manager/` にコピー
2. Godot エディタで Audio バスレイアウトに `BGM` と `SE` バスを追加
3. プロジェクト設定 → Autoload に `AudioManager.gd` を `AudioManager` として登録

## API

```gdscript
AudioManager.play_bgm(stream, fade_in)   # BGM 再生(fade_in 秒でフェードイン)
AudioManager.stop_bgm(fade_out)          # BGM 停止(fade_out 秒でフェードアウト)
AudioManager.play_se(stream)             # SE 再生
AudioManager.set_bgm_volume(0.0 ~ 1.0)  # BGM 音量設定(自動保存)
AudioManager.set_se_volume(0.0 ~ 1.0)   # SE 音量設定(自動保存)
AudioManager.get_bgm_volume()           # BGM 音量取得
AudioManager.get_se_volume()            # SE 音量取得
```
