module.exports =

  activate: (state) ->
    atom.commands.add "atom-workspace", "move-panes:move-right": => @moveRight()
    atom.commands.add "atom-workspace", "move-panes:move-left", => @moveLeft()
    atom.commands.add "atom-workspace", "move-panes:move-down", => @moveDown()
    atom.commands.add "atom-workspace", "move-panes:move-up", => @moveUp()
    atom.commands.add "atom-workspace", "move-panes:move-next", => @moveNext()
    atom.commands.add "atom-workspace", "move-panes:move-previous", => @movePrevious()

  moveRight: -> @move 'horizontal', +1
  moveLeft: -> @move 'horizontal', -1
  moveUp: -> @move 'vertical', -1
  moveDown: -> @move 'vertical', +1
  moveNext: -> @moveOrder @nextMethod
  movePrevious: -> @moveOrder @previousMethod

  nextMethod: 'activateNextPane'
  previousMethod: 'activatePreviousPane'

  active: -> atom.workspace.getActivePane()

  moveOrder: (method) ->
    source = @active()
    atom.workspace[method]()
    target = @active()
    @swapEditor source, target

  move: (orientation, delta) ->
    pane = atom.workspace.getActivePane()
    [axis,child] = @getAxis pane, orientation
    if axis?
      target = @getRelativePane axis, child, delta
    if target?
      @swapEditor pane, target

  swapEditor: (source, target) ->
    editor = source.getActiveItem()
    source.removeItem editor
    target.addItem editor
    target.activateItem editor
    target.activate()

  getAxis: (pane, orientation) ->
    axis = pane.parent
    child = pane
    while true
      return unless axis.constructor.name == 'PaneAxis'
      break if axis.orientation == orientation
      child = axis
      axis = axis.parent
    return [axis,child]

  getRelativePane: (axis, source, delta) ->
    position = axis.children.indexOf source
    target = position + delta
    return unless target < axis.children.length
    return axis.children[target].getPanes()[0]

  deactivate: ->

  serialize: ->
