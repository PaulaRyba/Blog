class PostService
  class PostError < StandardError; end
  class TitleEmpty < StandardError; end
  class ContentNotValid < StandardError; end
  class CategoryNotValid < StandardError; end

  attr_reader :post

  def initialize(post)
    @post = post
  end

  def process(title, content, category_id)
    raise TitleEmpty.new if title.empty?
    raise ContentNotValid.new if content.empty? or content.length < 5
    raise CategoryNotValid.new if category_id.empty?

    begin
      @post = Post.new(title:title, content:content, category_id:category_id)

      @post.save!
      return @post
      

    rescue 
      raise PostError.new $!.message
    end
  end
end