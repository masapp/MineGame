package org.masapp.minegame

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.MobileAds
import org.masapp.minegame.Constant.AdSettings
import java.io.IOException
import android.app.Activity
import android.graphics.Point
import android.widget.RelativeLayout
import org.masapp.minegame.Extension.dp


/**
 * Created by masapp on 2018/04/18.
 */
class GameActivity : Activity() {

  private lateinit var charactor: ImageView
  private lateinit var retryLabel: TextView
  private lateinit var titleLabel: TextView
  private lateinit var currentNumber: TextView
  private lateinit var stageInfo: ImageView
  private lateinit var stageInfoLabel: TextView

  private var wscale: Float = 0f
  private var hscale: Float = 0f
  private var squareWidth: Float = 0f
  private var squareHeight: Float = 0f
  private var groundWidth: Float = 0f
  private var groundHeight: Float = 0f
  private var stageCount: Int = 0
  private var status: String = ""
  private var map: List<List<Int>> = listOf()

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_game)

    val relativeLayout = findViewById(R.id.mainLayout) as RelativeLayout
    val displaySize = getDisplaySize(this)
    wscale = displaySize.x / 320f
    hscale = displaySize.y / 518f
    squareWidth = 21.5f * wscale
    squareHeight = 17f * hscale
    groundWidth = squareWidth * 0.975f
    groundHeight = squareHeight * 0.975f

    // ad
    MobileAds.initialize(this, AdSettings.appID)
    val adView = AdView(this)
    adView.adSize = AdSize.BANNER
    adView.adUnitId = AdSettings.unitID
    val adViewLP = RelativeLayout.LayoutParams(320.dp, 50.dp)
    adViewLP.addRule(RelativeLayout.CENTER_HORIZONTAL)
    adViewLP.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM)
    relativeLayout.addView(adView, adViewLP)
    val adRequest = AdRequest.Builder().build()
    adView.loadAd(adRequest)

    // background
    val background = ImageView(this)
    val backgroundImage = getBitmapFromAssets("ground/grass.png")
    background.setImageBitmap(backgroundImage)
    background.scaleType = ImageView.ScaleType.FIT_XY
    val backgroundLP = RelativeLayout.LayoutParams(displaySize.x, displaySize.y - 50.dp)
    backgroundLP.addRule(RelativeLayout.ALIGN_PARENT_TOP)
    relativeLayout.addView(background, backgroundLP)

    // charactor control button
    val control = ImageView(this)
    val controlImage = getBitmapFromAssets("footer/button_control.png")
    control.setImageBitmap(controlImage)
    val controlLP = RelativeLayout.LayoutParams((96 * wscale).toInt(), (96 * hscale).toInt())
    controlLP.leftMargin = (9.6 * wscale).toInt()
    controlLP.topMargin = displaySize.y - 50.dp - (96 * hscale).toInt()
    relativeLayout.addView(control, controlLP)

//    // chara at say numbers
//    let charactorRect = CGRect(x: 166.4 * wscale, y: 421 * hscale - 50 + safeAreaInsets.top, width: 150.4 * wscale, height: 96 * hscale)
//    let sayCharactor = UIImageView(frame: charactorRect)
//    sayCharactor.image = UIImage(named: "usayuki")
//    self.view.addSubview(sayCharactor)

    // charactor at say numbers
    val sayCharactor = ImageView(this)
    val sayCharactorImage = getBitmapFromAssets("footer/usayuki.png")
    sayCharactor.setImageBitmap(sayCharactorImage)
    val sayCharactorLP = RelativeLayout.LayoutParams((150.4 * wscale).toInt(), (96 * hscale).toInt())
    sayCharactorLP.leftMargin = (166.4 * wscale).toInt()
    sayCharactorLP.topMargin = displaySize.y - 50.dp - (96 * hscale).toInt()
    relativeLayout.addView(sayCharactor, sayCharactorLP)

//    // current number
//    currentNumber.frame = CGRect(x: 189 * wscale, y: 415 * hscale - 50 + safeAreaInsets.top, width: 96 * wscale, height: 96 * hscale)
//    currentNumber.font = UIFont.systemFont(ofSize: 70 * wscale)
//    self.view.addSubview(currentNumber)
//
//    // stage info
//    stageInfo.frame = CGRect(x: 0, y: 199 * hscale, width: windowSize.size.width, height: 51 * hscale)
//    stageInfo.image = UIImage(named: "info")
//    stageInfoLabel.frame = CGRect(x: 80 * wscale, y: 0, width: 499 * wscale, height: 51 * hscale)
//    stageInfoLabel.font = UIFont.systemFont(ofSize: 30 * wscale)
//    stageInfoLabel.textColor = .white
//        stageInfo.addSubview(stageInfoLabel)
//
//    retryLabel.frame = CGRect(x: 80 * wscale, y: 295 * hscale, width: 99 * wscale, height: 51 * hscale)
//    retryLabel.font = UIFont.systemFont(ofSize: 30 * wscale)
//    retryLabel.textColor = .white
//        retryLabel.text = "retry"
//
//    titleLabel.frame = CGRect(x: 202 * wscale, y: 295 * hscale, width: 99 * wscale, height: 51 * hscale)
//    titleLabel.font = UIFont.systemFont(ofSize: 30 * wscale)
//    titleLabel.textColor = .white
//        titleLabel.text = "title"
//
//    stageCount = 1
//
//    self.stageStart()
  }

  private fun getBitmapFromAssets(fileName: String): Bitmap? {
    return try {
      BitmapFactory.decodeStream(assets.open(fileName))
    } catch (e: IOException) {
      e.printStackTrace()
      null
    }
  }

  private fun getDisplaySize(activity: Activity): Point {
    val display = activity.windowManager.defaultDisplay
    val point = Point()
    display.getSize(point)
    return point
  }

}