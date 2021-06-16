package cn.leancloud.leanstoragegettingstarted;

import android.content.Intent;
import android.os.Bundle;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import java.util.ArrayList;
import java.util.List;

import cn.leancloud.LCObject;
import cn.leancloud.LCQuery;
import cn.leancloud.LCUser;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;

public class MainActivity extends AppCompatActivity {
  private RecyclerView mRecyclerView;
  private MainRecyclerAdapter mRecyclerAdapter;
  private List<LCObject> mList = new ArrayList<>();

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    final Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(toolbar);
    toolbar.setOnMenuItemClickListener(new Toolbar.OnMenuItemClickListener() {
      @Override
      public boolean onMenuItemClick(MenuItem item) {
        if (item.getItemId() == R.id.action_logout) {
          LCUser.getCurrentUser().logOut();
          startActivity(new Intent(MainActivity.this, LoginActivity.class));
          MainActivity.this.finish();
        }
        return false;
      }
    });

    FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
    fab.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {
        startActivity(new Intent(MainActivity.this, PublishActivity.class));
      }
    });

    mRecyclerView = (RecyclerView) findViewById(R.id.list_main);
    mRecyclerView.setHasFixedSize(true);
    mRecyclerView.setLayoutManager(new LinearLayoutManager(MainActivity.this));
    mRecyclerAdapter = new MainRecyclerAdapter(mList, MainActivity.this);
    mRecyclerView.setAdapter(mRecyclerAdapter);
  }

  @Override
  protected void onResume() {
    super.onResume();
    initData();
  }

  @Override
  protected void onPause() {
    super.onPause();
  }

  private void initData() {
    mList.clear();
    LCQuery<LCObject> avQuery = new LCQuery<>("Product");
    avQuery.orderByDescending("createdAt");
    avQuery.include("owner");
    avQuery.findInBackground().subscribe(new Observer<List<LCObject>>() {
      @Override
      public void onSubscribe(Disposable d) {

      }

      @Override
      public void onNext(List<LCObject> list) {
        mList.addAll(list);
        mRecyclerAdapter.notifyDataSetChanged();
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
  public boolean onCreateOptionsMenu(Menu menu) {
    // Inflate the menu; this adds items to the action bar if it is present.
    getMenuInflater().inflate(R.menu.menu_main, menu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    // Handle action bar item clicks here. The action bar will
    // automatically handle clicks on the Home/Up button, so long
    // as you specify a parent activity in AndroidManifest.xml.
    int id = item.getItemId();

    //noinspection SimplifiableIfStatement
    if (id == R.id.action_logout) {
      return true;
    }

    return super.onOptionsItemSelected(item);
  }
}
