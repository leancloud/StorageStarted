package cn.leancloud.leanstoragegettingstarted;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import cn.leancloud.AVObject;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;

public class DetailActivity extends AppCompatActivity {
  private TextView mName;
  private TextView mDescription;
  private ImageView mImage;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_detail);
    getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    getSupportActionBar().setTitle(getString(R.string.detail));

    mName = (TextView) findViewById(R.id.name_detail);
    mDescription = (TextView) findViewById(R.id.description_detail);
    mImage = (ImageView) findViewById(R.id.image_detail);

    String goodsObjectId = getIntent().getStringExtra("goodsObjectId");
    AVObject avObject = AVObject.createWithoutData("Product", goodsObjectId);
    avObject.fetchInBackground("owner").subscribe(new Observer<AVObject>() {
      @Override
      public void onSubscribe(Disposable d) {
      }
      @Override
      public void onNext(AVObject avObject) {
        mName.setText(avObject.getAVObject("owner") == null ? "" : avObject.getAVObject("owner").getString("username"));
        mDescription.setText(avObject.getString("description"));
        Picasso.with(DetailActivity.this).load(avObject.getAVFile("image") == null ? "www" : avObject.getAVFile("image").getUrl()).into(mImage);
      }
      @Override
      public void onError(Throwable e) {
      }
      @Override
      public void onComplete() {

      }
    });
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == android.R.id.home) {
      onBackPressed();
    }
    return super.onOptionsItemSelected(item);
  }
}
