class RenameContextToMicropost < ActiveRecord::Migration[5.0]
  def change
    rename_column :microposts, :context, :content  
  end
end
