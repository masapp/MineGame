package org.masapp.minegame

import android.os.Bundle
import android.support.constraint.ConstraintLayout
import android.support.constraint.ConstraintSet
import android.support.v7.app.AppCompatActivity
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.MobileAds
import org.masapp.minegame.Constant.AdSettings
import org.masapp.minegame.Extension.dp

/**
 * Created by masapp on 2018/04/18.
 */
class GameActivity : AppCompatActivity() {

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_game)

    MobileAds.initialize(this, AdSettings.appID)

    val constraintLayout = findViewById(R.id.constraintLayout) as ConstraintLayout
    val adView = AdView(this)
    adView.adSize = AdSize.BANNER
    adView.adUnitId = AdSettings.unitID
    constraintLayout.addView(adView)

    val constraintSet = ConstraintSet()
    constraintSet.clone(constraintLayout)
    constraintSet.connect(adView.id, ConstraintSet.LEFT, ConstraintSet.PARENT_ID, ConstraintSet.LEFT)
    constraintSet.connect(adView.id, ConstraintSet.RIGHT, ConstraintSet.PARENT_ID, ConstraintSet.RIGHT)
    constraintSet.connect(adView.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM)
    constraintSet.centerHorizontally(adView.id, ConstraintSet.PARENT_ID)
    constraintSet.constrainHeight(adView.id, 50.dp)
    constraintSet.applyTo(constraintLayout)

    val adRequest = AdRequest.Builder().build()
    adView.loadAd(adRequest)
  }
}