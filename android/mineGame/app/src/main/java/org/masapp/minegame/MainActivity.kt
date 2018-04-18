package org.masapp.minegame

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdView
import org.masapp.minegame.Constant.AdSettings

class MainActivity : AppCompatActivity() {

  lateinit var adView: AdView

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

    MobileAds.initialize(this, AdSettings.appID)

    adView = findViewById(R.id.adView)
    val adRequest = AdRequest.Builder().build()
    adView.loadAd(adRequest)
  }
}
