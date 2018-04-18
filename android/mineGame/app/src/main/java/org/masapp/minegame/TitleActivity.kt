package org.masapp.minegame

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.constraint.ConstraintLayout
import android.support.constraint.ConstraintSet
import android.view.MotionEvent
import android.widget.ImageView
import java.io.IOException

/**
 * Created by masapp on 2018/04/18.
 */
class TitleActivity : Activity() {

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_title)

    val constraintLayout = findViewById(R.id.constraintLayout) as ConstraintLayout
    val imageView = ImageView(this)
    val titleImage = getBitmapFromAssets("title.png")
    imageView.setImageBitmap(titleImage)
    imageView.scaleType = ImageView.ScaleType.FIT_XY
    constraintLayout.addView(imageView)

    val constraintSet = ConstraintSet()
    constraintSet.clone(constraintLayout)
    constraintSet.connect(imageView.id, ConstraintSet.LEFT, ConstraintSet.PARENT_ID, ConstraintSet.LEFT)
    constraintSet.connect(imageView.id, ConstraintSet.RIGHT, ConstraintSet.PARENT_ID, ConstraintSet.RIGHT)
    constraintSet.connect(imageView.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM)
    constraintSet.connect(imageView.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP)
    constraintSet.applyTo(constraintLayout)
  }

  override fun onTouchEvent(event: MotionEvent?): Boolean {
    if (event?.action == MotionEvent.ACTION_DOWN) {
      val intent = Intent(this, GameActivity::class.java)
      startActivity(intent)
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
}
