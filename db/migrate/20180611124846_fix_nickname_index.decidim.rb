# frozen_string_literal: true

# This migration comes from decidim (originally 20180221101934)

class FixNicknameIndex < ActiveRecord::Migration[5.1]
  class User < ApplicationRecord
    self.table_name = :decidim_users
  end

  def change
    User.where(nickname: nil)
        .where(deleted_at: nil)
        .where(managed: false)
        .find_each { |u| u.update(nickname: User.nicknamize(u.name)) }

    User.where(nickname: nil).update_all("nickname = ''")
    change_column_default :decidim_users, :nickname, ""
    change_column_null(:decidim_users, :nickname, false)
  end
end
