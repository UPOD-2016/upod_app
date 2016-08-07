# frozen_string_literal: true
# HeadingTextBlock is a subclass of {ArticleTextBlock}
# When rendered, its body is intended to be displayed as a header.
#
# @see ArticleTextBlock
#
# author: Steven Swartz
#
# == Schema Information
#
# Table name: article_text_blocks
#
#  id   :integer          not null, primary key
#  body :text(65535)
#  type :text(256)
#
class HeadingTextBlock < ArticleTextBlock
  # Used by SirTrevor for updating
  def as_json
    {
      type: :heading,
      data:
        {
          text: body,
          format: :html
        }
    }
  end
end
