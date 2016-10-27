package cn.leancloud.leanstoragegettingstarted;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.TextView;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.GetCallback;
import com.avos.avoscloud.AVAnalytics;
import com.squareup.picasso.Picasso;

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
    avObject.fetchInBackground("owner", new GetCallback<AVObject>() {
      @Override
      public void done(AVObject avObject, AVException e) {
        mName.setText(avObject.getAVUser("owner") == null ? "" : avObject.getAVUser("owner").getUsername());
        mDescription.setText(avObject.getString("description"));
        Picasso.with(DetailActivity.this).load(avObject.getAVFile("image") == null ? "www" : avObject.getAVFile("image").getUrl()).into(mImage);
      }
    });
  }

  @Override
  protected void onPause() {
    super.onPause();
    AVAnalytics.onPause(this);
  }

  @Override
  protected void onResume() {
    super.onResume();
    AVAnalytics.onResume(this);
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == android.R.id.home) {
      onBackPressed();
    }
    return super.onOptionsItemSelected(item);
  }
}
