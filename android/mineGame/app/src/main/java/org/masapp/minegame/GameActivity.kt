package org.masapp.minegame

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.MobileAds
import org.masapp.minegame.Constant.AdSettings
import java.io.IOException
import android.app.Activity
import android.graphics.Color
import android.graphics.Point
import android.os.Handler
import android.view.MotionEvent
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
  private lateinit var backImage: Bitmap
  private lateinit var frontImage: Bitmap
  private lateinit var leftImage: Bitmap
  private lateinit var rightImage: Bitmap
  private lateinit var relativeLayout: RelativeLayout
  private lateinit var zeroImage: Bitmap
  private lateinit var oneImage: Bitmap
  private lateinit var twoImage: Bitmap
  private lateinit var threeImage: Bitmap
  private lateinit var fourImage: Bitmap
  private lateinit var fiveImage: Bitmap
  private lateinit var sixImage: Bitmap
  private lateinit var sevenImage: Bitmap
  private lateinit var eightImage: Bitmap
  private lateinit var nineImage: Bitmap

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

    relativeLayout = findViewById(R.id.mainLayout) as RelativeLayout
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
    background.layoutParams = backgroundLP
    relativeLayout.addView(background)

    // charactor control button
    val control = ImageView(this)
    val controlImage = getBitmapFromAssets("footer/button_control.png")
    control.setImageBitmap(controlImage)
    val controlLP = RelativeLayout.LayoutParams((96 * wscale).toInt(), (96 * hscale).toInt())
    controlLP.leftMargin = (9.6 * wscale).toInt()
    controlLP.topMargin = (421 * hscale).toInt() - 50.dp
    control.layoutParams = controlLP
    relativeLayout.addView(control)

    // charactor at say numbers
    val sayCharactor = ImageView(this)
    val sayCharactorImage = getBitmapFromAssets("footer/usayuki.png")
    sayCharactor.setImageBitmap(sayCharactorImage)
    val sayCharactorLP = RelativeLayout.LayoutParams((150.4 * wscale).toInt(), (96 * hscale).toInt())
    sayCharactorLP.leftMargin = (166.4 * wscale).toInt()
    sayCharactorLP.topMargin = (421 * hscale).toInt() - 50.dp
    sayCharactor.layoutParams = sayCharactorLP
    relativeLayout.addView(sayCharactor)

    // current number
    currentNumber = TextView(this)
    currentNumber.setTextColor(Color.BLACK)
    currentNumber.textSize = 25 * wscale
    val currentNumberLP = RelativeLayout.LayoutParams((96 * wscale).toInt(), (96 * hscale).toInt())
    currentNumberLP.leftMargin = (185 * wscale).toInt()
    currentNumberLP.topMargin = (417 * hscale).toInt() - 50.dp
    currentNumber.layoutParams = currentNumberLP
    relativeLayout.addView(currentNumber)

    // stage info
    stageInfo = ImageView(this)
    val stageInfoImage = getBitmapFromAssets("info.png")
    stageInfo.setImageBitmap(stageInfoImage)
    val stageInfoLP = RelativeLayout.LayoutParams(displaySize.x, (51 * hscale).toInt())
    stageInfoLP.topMargin = (199 * hscale).toInt()
    stageInfo.layoutParams = stageInfoLP
    stageInfoLabel = TextView(this)
    stageInfoLabel.setTextColor(Color.WHITE)
    stageInfoLabel.textSize = 11 * wscale
    stageInfoLabel.textAlignment = TextView.TEXT_ALIGNMENT_CENTER
    val stageInfoLabelLP = RelativeLayout.LayoutParams(displaySize.x, (51 * hscale).toInt())
    stageInfoLabelLP.topMargin = (199 * hscale).toInt()
    stageInfoLabel.layoutParams = stageInfoLabelLP

    retryLabel = TextView(this)
    retryLabel.setTextColor(Color.WHITE)
    retryLabel.textSize = 11 * wscale
    retryLabel.text = "retry"
    val retryLabelLP = RelativeLayout.LayoutParams((99 * wscale).toInt(), (51 * hscale).toInt())
    retryLabelLP.leftMargin = (50 * wscale).toInt()
    retryLabelLP.topMargin = (295 * hscale).toInt()
    retryLabel.layoutParams = retryLabelLP

    titleLabel = TextView(this)
    titleLabel.setTextColor(Color.WHITE)
    titleLabel.textSize = 11 * wscale
    titleLabel.text = "title"
    val titleLabelLP = RelativeLayout.LayoutParams((99 * wscale).toInt(), (51 * hscale).toInt())
    titleLabelLP.leftMargin = (210 * wscale).toInt()
    titleLabelLP.topMargin = (295 * hscale).toInt()
    titleLabel.layoutParams = titleLabelLP

    stageCount = 1

    createCharactorBitmapImage()
    createBombNumberImage()
    stageStart()
  }

  override fun onTouchEvent(event: MotionEvent?): Boolean {
    if (event?.action == MotionEvent.ACTION_DOWN) {
      when (status) {
        "play" -> {
          // up or down
          if (41.5 * wscale <= event.x && event.x <= 75 * wscale) {
            if (425 * hscale - 50.dp <= event.y && event.y <= 455.5 * hscale - 50.dp) {
              charactor.setImageBitmap(backImage)
              moveCharactor(0f, -squareHeight)
            } else if (485 * hscale - 50.dp <= event.y && event.y <= 515 * hscale - 50.dp) {
              charactor.setImageBitmap(frontImage)
              moveCharactor(0f, squareHeight)
            }
          }
          // left or right
          if (455.5 * hscale - 50.dp <= event.y && event.y <= 485 * hscale - 50.dp) {
            if (10 * wscale <= event.x && event.x <= 42 * wscale) {
              charactor.setImageBitmap(leftImage)
              moveCharactor(-squareWidth, 0f)
            } else if (77 * wscale <= event.x && event.x <= 105 * wscale) {
              charactor.setImageBitmap(rightImage)
              moveCharactor(squareWidth, 0f)
            }
          }
        }
        "gameOver" -> {
          if (312 * hscale <= event.y && event.y <= 340 * hscale) {
            if (50 * wscale <= event.x && event.x <= 115 * wscale) {
              stageCount = 1
              relativeLayout.removeView(stageInfo)
              relativeLayout.removeView(stageInfoLabel)
              relativeLayout.removeView(retryLabel)
              relativeLayout.removeView(titleLabel)
              stageStart()
            } else if (203 * wscale <= event.x && event.x <= 263 * wscale) {
              finish()
            }
          }
        }
      }
    }
    return true
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

  private fun createCharactorBitmapImage() {
    getBitmapFromAssets("charactor/back.png")?.let {
      backImage = it
    }
    getBitmapFromAssets("charactor/front.png")?.let {
      frontImage = it
    }
    getBitmapFromAssets("charactor/left.png")?.let {
      leftImage = it
    }
    getBitmapFromAssets("charactor/right.png")?.let {
      rightImage = it
    }
  }

  private fun createBombNumberImage() {
    getBitmapFromAssets("number/0.png")?.let {
      zeroImage = it
    }
    getBitmapFromAssets("number/1.png")?.let {
      oneImage = it
    }
    getBitmapFromAssets("number/2.png")?.let {
      twoImage = it
    }
    getBitmapFromAssets("number/3.png")?.let {
      threeImage = it
    }
    getBitmapFromAssets("number/4.png")?.let {
      fourImage = it
    }
    getBitmapFromAssets("number/5.png")?.let {
      fiveImage = it
    }
    getBitmapFromAssets("number/6.png")?.let {
      sixImage = it
    }
    getBitmapFromAssets("number/7.png")?.let {
      sevenImage = it
    }
    getBitmapFromAssets("number/8.png")?.let {
      eightImage = it
    }
    getBitmapFromAssets("number/9.png")?.let {
      nineImage = it
    }
  }

  private fun drawMap(mapArray: List<List<Int>>) {
    drawGround(mapArray)
    drawFence()
  }

  private fun drawGround(mapArray: List<List<Int>>) {
    // draw ground
    val groundImage = getBitmapFromAssets("ground/soil.png")
    for (i in 0 .. mapArray.size - 1) {
      for (j in 0 .. mapArray[i].size - 1) {
        // ground
        val ground = ImageView(this)
        ground.setImageBitmap(groundImage)
        val groundLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
        groundLP.leftMargin = (squareWidth * (j + 1)).toInt()
        groundLP.topMargin = (squareHeight * (i + 1)).toInt()
        ground.layoutParams = groundLP
        relativeLayout.addView(ground)
      }
    }
  }

  private fun drawFence() {
    // left top corner
    val leftTopCornerImage = getBitmapFromAssets("fence/left_top_corner.png")
    val leftTopCorner = ImageView(this)
    leftTopCorner.setImageBitmap(leftTopCornerImage)
    leftTopCorner.scaleType = ImageView.ScaleType.FIT_XY
    val leftTopCornerLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
    leftTopCorner.layoutParams = leftTopCornerLP
    relativeLayout.addView(leftTopCorner)

    // right top corner
    val rightTopCornerImage = getBitmapFromAssets("fence/right_top_corner.png")
    val rightTopCorner = ImageView(this)
    rightTopCorner.setImageBitmap(rightTopCornerImage)
    rightTopCorner.scaleType = ImageView.ScaleType.FIT_XY
    val rightTopCornerLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
    rightTopCornerLP.leftMargin = (squareWidth * 14).toInt()
    rightTopCorner.layoutParams = rightTopCornerLP
    relativeLayout.addView(rightTopCorner)

    // left under corner
    val leftUnderCornerImage = getBitmapFromAssets("fence/left_under_corner.png")
    val leftUnderCorner = ImageView(this)
    leftUnderCorner.setImageBitmap(leftUnderCornerImage)
    leftUnderCorner.scaleType = ImageView.ScaleType.FIT_XY
    val leftUnderCornerLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
    leftUnderCornerLP.topMargin = (squareHeight * 21).toInt()
    leftUnderCorner.layoutParams = leftUnderCornerLP
    relativeLayout.addView(leftUnderCorner)

    // right under corner
    val rightUnderCornerImage = getBitmapFromAssets("fence/right_under_corner.png")
    val rightUnderCorner = ImageView(this)
    rightUnderCorner.setImageBitmap(rightUnderCornerImage)
    rightUnderCorner.scaleType = ImageView.ScaleType.FIT_XY
    val rightUnderCornerLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
    rightUnderCornerLP.leftMargin = (squareWidth * 14).toInt()
    rightUnderCornerLP.topMargin = (squareHeight * 21).toInt()
    rightUnderCorner.layoutParams = rightUnderCornerLP
    relativeLayout.addView(rightUnderCorner)

    // height
    val heightImage = getBitmapFromAssets("fence/height.png")
    for (i in 0 .. 19) {
      val leftHeight = ImageView(this)
      leftHeight.setImageBitmap(heightImage)
      leftHeight.scaleType = ImageView.ScaleType.FIT_XY
      val leftHeightLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      leftHeightLP.topMargin = (squareHeight * (i + 1)).toInt()
      leftHeight.layoutParams = leftHeightLP
      relativeLayout.addView(leftHeight)

      val rightHeight = ImageView(this)
      rightHeight.setImageBitmap(heightImage)
      rightHeight.scaleType = ImageView.ScaleType.FIT_XY
      val rightHeightLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      rightHeightLP.leftMargin = (squareWidth * 14).toInt()
      rightHeightLP.topMargin = (squareHeight * (i + 1)).toInt()
      rightHeight.layoutParams = rightHeightLP
      relativeLayout.addView(rightHeight)
    }

    // width
    val widthImage = getBitmapFromAssets("fence/width.png")
    for (i in 0 .. 4) {
      val leftTopWidth = ImageView(this)
      leftTopWidth.setImageBitmap(widthImage)
      leftTopWidth.scaleType = ImageView.ScaleType.FIT_XY
      val leftTopWidthLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      leftTopWidthLP.leftMargin = (squareWidth * (i + 1)).toInt()
      leftTopWidth.layoutParams = leftTopWidthLP
      relativeLayout.addView(leftTopWidth)

      val rightTopWidth = ImageView(this)
      rightTopWidth.setImageBitmap(widthImage)
      rightTopWidth.scaleType = ImageView.ScaleType.FIT_XY
      val rightTopWidthLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      rightTopWidthLP.leftMargin = (squareWidth * (i + 9)).toInt()
      rightTopWidth.layoutParams = rightTopWidthLP
      relativeLayout.addView(rightTopWidth)

      val leftUnderWidth = ImageView(this)
      leftUnderWidth.setImageBitmap(widthImage)
      leftUnderWidth.scaleType = ImageView.ScaleType.FIT_XY
      val leftUnderWidthLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      leftUnderWidthLP.leftMargin = (squareWidth * (i + 1)).toInt()
      leftUnderWidthLP.topMargin = (squareHeight * 21).toInt()
      leftUnderWidth.layoutParams = leftUnderWidthLP
      relativeLayout.addView(leftUnderWidth)

      val rightUnderWidth = ImageView(this)
      rightUnderWidth.setImageBitmap(widthImage)
      rightUnderWidth.scaleType = ImageView.ScaleType.FIT_XY
      val rightUnderWidthLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      rightUnderWidthLP.leftMargin = (squareWidth * (i + 9)).toInt()
      rightUnderWidthLP.topMargin = (squareHeight * 21).toInt()
      rightUnderWidth.layoutParams = rightUnderWidthLP
      relativeLayout.addView(rightUnderWidth)
    }

    // start and end
    val leftEndImage = getBitmapFromAssets("fence/left_end.png")
    val rightEndImage = getBitmapFromAssets("fence/right_end.png")
    val flatImage = getBitmapFromAssets("ground/grass.png")
    for (i in 0 .. 1) {
      val leftEnd = ImageView(this)
      leftEnd.setImageBitmap(leftEndImage)
      leftEnd.scaleType = ImageView.ScaleType.FIT_XY
      val leftEndLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      leftEndLP.leftMargin = (squareWidth * 8).toInt()
      leftEndLP.topMargin = (squareHeight * (i * 21)).toInt()
      leftEnd.layoutParams = leftEndLP
      relativeLayout.addView(leftEnd)

      val rightEnd = ImageView(this)
      rightEnd.setImageBitmap(rightEndImage)
      rightEnd.scaleType = ImageView.ScaleType.FIT_XY
      val rightEndLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      rightEndLP.leftMargin = (squareWidth * 6).toInt()
      rightEndLP.topMargin = (squareHeight * (i * 21)).toInt()
      rightEnd.layoutParams = rightEndLP
      relativeLayout.addView(rightEnd)

      val flat = ImageView(this)
      flat.setImageBitmap(flatImage)
      flat.scaleType = ImageView.ScaleType.FIT_XY
      val flatLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      flatLP.leftMargin = (squareWidth * 7).toInt()
      flatLP.topMargin = (squareHeight * (i * 21)).toInt()
      flat.layoutParams = flatLP
      relativeLayout.addView(flat)
    }
  }

  // put the charactor to the start position
  private fun setCharactor() {
    val charactorLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
    charactorLP.leftMargin = (squareWidth * 7).toInt()
    charactorLP.topMargin = (squareHeight * 21).toInt()
    charactor = ImageView(this)
    charactor.setImageBitmap(backImage)
    charactor.scaleType = ImageView.ScaleType.FIT_XY
    charactor.layoutParams = charactorLP
    relativeLayout.addView(charactor)
  }

  private fun moveCharactor(pointX: Float, pointY: Float) {
    val nowPointX = charactor.x
    val nowPointY = charactor.y
    if (moveValidate(pointX, pointY)) {
      return
    }

    // charactor move
    charactor.x = nowPointX + pointX
    charactor.y = nowPointY + pointY

    if ((charactor.x).toInt() == (squareWidth * 7).toInt() && (charactor.y).toInt() == 0) {
      stageComplete()
      return
    }

    // check bomb
    checkBomb(Point(charactor.x.toInt(), charactor.y.toInt()))
  }

  private fun moveValidate(pointX: Float, pointY: Float): Boolean {
    val nowPointX = charactor.x
    val nowPointY = charactor.y

    // start position
    if (nowPointX.toInt() == (squareWidth * 7).toInt() && nowPointY.toInt() == (squareHeight * 21).toInt()) {
      if (pointX.toInt() != 0) {
        return true
      }
    }

    // left validate
    if (nowPointX <= squareWidth && pointX == -squareWidth) {
      return true
    }

    // right validate
    if ((nowPointX + 1).toInt() >= (squareWidth * 13).toInt() && pointX == squareWidth) {
      return true
    }

    // down validate
    if (Math.round(nowPointY) >= Math.round(squareHeight * 20) && pointY == squareHeight) {
      return true
    }

    // up validate
    if (Math.round(nowPointY) <= Math.round(squareHeight) && pointY == -squareHeight) {
      if (nowPointX.toInt() != (squareWidth * 7).toInt() || Math.round(nowPointY) != Math.round(squareHeight)) {
        return true
      }
    }

    return false
  }

  private fun stageStart() {
    // disable touch events
    relativeLayout.isEnabled = false

    val mapGenerator = MapGenerator()
    map = mapGenerator.towDimensionalArrayForMap()
    drawMap(map)

    // current square number init
    currentNumber.text = ""

    // put the charactor to the start position
    setCharactor()

    // show next stage count
    relativeLayout.addView(stageInfo)
    stageInfoLabel.text = "stage ${stageCount} start"
    relativeLayout.addView(stageInfoLabel)

    // timer to hide stage info
    Handler().postDelayed(Runnable {
      // enable touch events
      relativeLayout.isEnabled = true
      relativeLayout.removeView(stageInfo)
      relativeLayout.removeView(stageInfoLabel)
      status = "play"
    }, 2000)
  }

  private fun stageComplete() {
    // disable touch events
    relativeLayout.isEnabled = false

    // show stage clear info
    relativeLayout.addView(stageInfo)
    stageInfoLabel.text = "stage ${stageCount} clear"
    relativeLayout.addView(stageInfoLabel)

    stageCount += 1

    // timer to hide clear info
    Handler().postDelayed(Runnable {
      // enable touch events
      relativeLayout.isEnabled = true
      relativeLayout.removeView(stageInfo)
      relativeLayout.removeView(stageInfoLabel)

      stageStart()
    }, 2000)
  }

  private fun getSquareNumber(point: Point): Int {
    val i = Math.round(point.y / squareHeight - 1)
    val j = Math.round(point.x / squareWidth - 1)
    return map[i][j]
  }

  private fun checkBomb(point: Point) {
    val squareNumber = getSquareNumber(point)
    if (squareNumber == -1) {
      relativeLayout.addView(stageInfo)
      stageInfoLabel.text = "game over"
      relativeLayout.addView(stageInfoLabel)
      status = "gameOver"

      relativeLayout.addView(retryLabel)
      relativeLayout.addView(titleLabel)
    } else {
      // current square number
      currentNumber.text = squareNumber.toString()

      // bomb count
      val bombCount = ImageView(this)
      bombCount.setImageBitmap(getNumberImage(squareNumber))
      val bombCountLP = RelativeLayout.LayoutParams(groundWidth.toInt(), groundHeight.toInt())
      bombCountLP.leftMargin = point.x
      bombCountLP.topMargin = point.y
      bombCount.layoutParams = bombCountLP
      relativeLayout.addView(bombCount)
      charactor.bringToFront()
    }
  }

  private fun getNumberImage(number: Int): Bitmap? {
    when (number) {
      0 -> return zeroImage
      1 -> return oneImage
      2 -> return twoImage
      3 -> return threeImage
      4 -> return fourImage
      5 -> return fiveImage
      6 -> return sixImage
      7 -> return sevenImage
      8 -> return eightImage
      9 -> return nineImage
    }
    return null
  }
}