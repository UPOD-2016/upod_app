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
#
class HeadingTextBlock < ArticleTextBlock
  # Used by SirTrevor for updating
  def as_json
    {
      type: :heading,
        data: {
          text: self.body,
          format: :html
        }
    }
  end
end
