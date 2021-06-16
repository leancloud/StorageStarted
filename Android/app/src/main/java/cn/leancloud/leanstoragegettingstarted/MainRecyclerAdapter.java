package cn.leancloud.leanstoragegettingstarted;

import android.content.Context;
import android.content.Intent;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import java.util.List;

import cn.leancloud.LCObject;

/**
 * Created by BinaryHB on 11/24/15.
 */
public class MainRecyclerAdapter extends RecyclerView.Adapter<MainRecyclerAdapter.MainViewHolder> {
  private Context mContext;
  private List<LCObject> mList;

  public MainRecyclerAdapter(List<LCObject> list, Context context) {
    this.mContext = context;
    this.mList = list;
  }

  @Override
  public MainViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
    return new MainViewHolder(LayoutInflater.from(mContext).inflate(R.layout.item_list_main, parent, false));
  }

  @Override
  public void onBindViewHolder(MainViewHolder holder, final int position) {
    holder.mTitle.setText((CharSequence) mList.get(position).get("title"));
    holder.mPrice.setText(mList.get(position).get("price") == null ? "￥" : "￥ " + mList.get(position).get("price"));
    holder.mName.setText(mList.get(position).getLCObject("owner") == null ? "" : mList.get(position).getLCObject("owner").getString("username"));
    Picasso.with(mContext).load(mList.get(position).getLCFile("image") == null ? "www" : mList.get(position).getLCFile("image").getUrl()).transform(new RoundedTransformation(9, 0)).into(holder.mPicture);
    holder.mItem.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {
        Intent intent = new Intent(mContext, DetailActivity.class);
        intent.putExtra("goodsObjectId", mList.get(position).getObjectId());
        mContext.startActivity(intent);
      }
    });
  }

  @Override
  public int getItemCount() {
    return mList.size();
  }

  class MainViewHolder extends RecyclerView.ViewHolder {
    private TextView mName;
    private TextView mPrice;
    private TextView mTitle;
    private CardView mItem;
    private ImageView mPicture;

    public MainViewHolder(View itemView) {
      super(itemView);
      mName = (TextView) itemView.findViewById(R.id.name_item_main);
      mTitle = (TextView) itemView.findViewById(R.id.title_item_main);
      mPrice = (TextView) itemView.findViewById(R.id.price_item_main);
      mPicture = (ImageView) itemView.findViewById(R.id.picture_item_main);
      mItem = (CardView) itemView.findViewById(R.id.item_main);
    }
  }
}
