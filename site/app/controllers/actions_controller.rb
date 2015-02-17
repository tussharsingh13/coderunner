class ActionsController < ApplicationController
  def submit
  end

 def editor
  @solution = Solution.new
 end
 
 def submitcode
  @solution = Solution.new(solution_params)
  path = "public/submissions/code1.txt"
  content = @solution.code
  File.open(path, "w+") do |f|
  f.write(content)
  end
  
 end
  
  private
  def solution_params
    params.require(:solution).permit(:problem,:code)
  end
  
end
