# EquationTextBlock is a subclass of {ArticleTextBlock}
# When rendered, some of its body may contain
# mathematical expressions to be typeset
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
class EquationTextBlock < ArticleTextBlock
  # Used by SirTrevor for updating
  def as_json
    {
      type: :equation_text,
      data:
        {
          text: body,
          format: :html
        }
    }
  end
end
