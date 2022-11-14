# TODO: need to run `sudo yabai --load-sa` on reboot for scripting addition to work

GRID_WIDTH=3
GRID_HEIGHT=3
GRID_SPACES=9 # TODO: compute

function -yabai-2d-grid {
  yabai -m space $SPACE --create
}

function -yabai-reset {
  SPACE_COUNT=$(yabai -m query --spaces | jq 'length')
  echo "SPACE_COUNT: ${SPACE_COUNT}"
  echo "GRID_SPACES: ${GRID_SPACES}"
  if [[ $SPACE_COUNT -lt $GRID_SPACES ]]; then
    echo 'need more spaces'
    for i in {1..$(expr $GRID_SPACES - $SPACE_COUNT)}; do
      echo 'todo: add space'
    done
  else if [[ $SPACE_COUNT -gt $GRID_SPACES ]];
    echo 'need fewer spaces'
    for i in {1..$(expr $SPACE_COUNT - $GRID_SPACES)}; do
      echo 'todo: remove space'
    done
  fi

  # Apply labels
  for row_idx in {0..$(expr $GRID_HEIGHT - 1)}; do
    for col_idx in {0..$(expr $GRID_WIDTH - 1)}; do
      yabai -m 
    done
  done
  for row_idx in 0..GRID_HEIGHT
    for col_idx in 0..GRID_WIDTH
      yabai -m space {space_index}
}

function -yabai-coord-to-space-idx {
  ROW=$1
  COL=$2
  
  # ROW * GRID_WIDTH + COL
}

function -yabai-space-idx-row { expr $1 / $GRID_HEIGHT }
function -yabai-space-idx-col { expr $1 / $GRID_WIDTH }

function -yabai-focused-space-idx {
  yabai -m query --spaces | jq '.[] | select(.focused == 1) | .index'
}

function -yabai-focused-window-id {
  yabai -m query --windows | jq '.[] | select(.focused == 1) | .id'
}

# TODO:
# + Set up/reset grid
#   + Label spaces as 'grid{row}x{column}' for easier referencing and debugging
# + Get clamped adjacent space
