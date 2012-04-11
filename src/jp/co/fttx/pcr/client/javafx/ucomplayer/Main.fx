package jp.co.fttx.pcr.client.javafx.ucomplayer;

import javafx.stage.*;
import javafx.scene.*;
import jp.co.fttx.pcr.client.javafx.ucomplayer.UcomPlayer;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;

/**
 * <p>メイン</p>
 * 機能：UCOM-DRM復号、動画ファイル再生
 * @author UCOM#tooru.oguri
 */
var index = 0;
var media = [
            "No Media"
        ];
var mediaTitles = [
            "No Media Titles"
        ];
var mediaDescriptions = [
            "No Media Descriptions"
        ];
/** JNLP使用時に利用可能な外部引数 */
var theme = getFXArgString("theme", "paranara");
var mediaUrl = getFXArgString("mediaURL", media[0]);
Alert.inform("mediaUrl:{mediaUrl}");
var mediaViewWidth = getFXArgInt("mediaViewWidth", getWidth());
var mediaViewHeight = getFXArgInt("mediaViewHeight", getHeight());
var mediaTitle = getFXArgString("mediaTitle", mediaTitles[0]);
var mediaDescription = getFXArgString("mediaDescription", mediaDescriptions[0]);
var mediaCurrentTime = getFXArgDuration("mediaCurrentTime", 0ms);
/** UCOM Player */
var ucomPlayer: UcomPlayer = UcomPlayer {
            mediaSource: mediaUrl
            mediaTitle: mediaTitle
            mediaDescription: mediaDescription
            mediaCurrentTime: mediaCurrentTime
            autoPlay: true
            preserveRatio: true

            width: bind ucomPlayer.scene.width
            height: bind ucomPlayer.scene.height
            layoutX: 0;
            layoutY: 0;

            // view
            themeStr: theme
            mediaControlBarHeight: 25
            showMediaInfo: true

            // function variables
            onEndOfMedia: function() {
                index++;
                index = index mod sizeof media;
                ucomPlayer.mediaSource = media[index];
                ucomPlayer.mediaTitle = mediaTitles[index];
                ucomPlayer.mediaDescription = mediaDescriptions[index];
                ucomPlayer.mediaCurrentTime = mediaCurrentTime;
            }
            onMouseClicked: function(me) {
                index++;
                index = index mod sizeof media;
                ucomPlayer.mediaSource = media[index];
                ucomPlayer.mediaTitle = mediaTitles[index];
                ucomPlayer.mediaDescription = mediaDescriptions[index];
                ucomPlayer.mediaCurrentTime = mediaCurrentTime;
            }

            onKeyPressed: function(e: KeyEvent): Void {
                if ((e.code == KeyCode.VK_RIGHT) or (e.code == KeyCode.VK_TRACK_NEXT)) {
                    index++;
                    index = index mod sizeof media;
                    ucomPlayer.mediaSource = media[index];
                    ucomPlayer.mediaTitle = mediaTitles[index];
                    ucomPlayer.mediaDescription = mediaDescriptions[index];
                    ucomPlayer.showMediaInfo = true;
                    ucomPlayer.mediaCurrentTime = mediaCurrentTime;
                } else if ((e.code == KeyCode.VK_LEFT) or (e.code == KeyCode.VK_TRACK_PREV)) {
                    index--;
                    if (index < 0) index = sizeof media - 1;
                    index = index mod sizeof media;
                    ucomPlayer.mediaSource = media[index];
                    ucomPlayer.mediaTitle = mediaTitles[index];
                    ucomPlayer.mediaDescription = mediaDescriptions[index];
                    ucomPlayer.mediaCurrentTime = mediaCurrentTime;
                } else if (e.code == KeyCode.VK_POWER) { FX.exit(); } else if (e.code == KeyCode.VK_UP) {
                    ucomPlayer.mediaControlBar.show = true;
                    ucomPlayer.showMediaInfo = true;
                } else if (e.code == KeyCode.VK_DOWN) {
                    ucomPlayer.mediaControlBar.show = false;
                    ucomPlayer.showMediaInfo = false;
                } else if ((e.code == KeyCode.VK_BACK_SPACE) or (e.code == KeyCode.VK_Q) or (e.code == KeyCode.VK_POWER)) {
                    FX.exit();
                }
            }
        }

Stage {
    title: "UCOM Player"
    resizable: true

    scene: Scene {
        width: mediaViewWidth
        height: mediaViewHeight
        content: ucomPlayer
    }
}

ucomPlayer.requestFocus();

function getWidth(): Number {

    if ({ __PROFILE__ } == "desktop")
        return 640 else
        return 1280
}

function getHeight(): Number {

    if ({ __PROFILE__ } == "desktop")
        return 360 else
        return 720
}

function getFXArgString(arg: String, defaultValue: String): String {
    var val = FX.getArgument(arg);
    if (val == null or "".equals(val)) {
        return defaultValue;
    }
    return val as String;
}

function getFXArgInt(arg: String, defaultValue: Integer): Integer {
    var val = FX.getArgument(arg);
    if (val == null) {
        return defaultValue;
    }
    try {
        return Integer.parseInt(val as String);
    } catch (nfe: java.lang.NumberFormatException) {
        return defaultValue;
    }
}

function getFXArgDuration(arg: String, defaultValue: Duration): Duration {
    var val = FX.getArgument(arg);
    if (val == null) {
        return defaultValue;
    }
    try {
        return Duration.valueOf(Integer.parseInt(val as String));
    } catch (nfe: java.lang.NumberFormatException) {
        return defaultValue;
    }
}

