# coderunner
Online judge with a special touch

The welcome page is located at site/public/welcome.html
Consider it as the index for now.
We'll find some way to make it index.

Submit and Editor pages have been created.
Controller of both of them is actions_controller.rb located at site/apps/controllers/actions_controller.rb
Both have different views located at 
site/app/views/actions/submit.html.erb and
site/app/views/actions/editor.html.erb respectively.

EDITOR:
A simple form was created for editor with attributes: Problem Name and Code.
Solution Model has been created.
Open-source code editor CodeMirror was integrated with the text area in editor.html.erb.
Currently, the editor has colour code for Javascript.
When submit button is pressed, the code gets stored in public/submissions and the view submitcode.html.erb is rendered.


