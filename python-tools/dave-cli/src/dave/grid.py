import tabulate

MOVEMENT_DIRECTION_OFFSETS = {
    'up':    { 'row_offset': -1, 'column_offset':  0 },
    'down':  { 'row_offset':  1, 'column_offset':  0 },
    'left':  { 'row_offset':  0, 'column_offset': -1 },
    'right': { 'row_offset':  0, 'column_offset':  1 },
}
MOVEMENT_DIRECTIONS = MOVEMENT_DIRECTION_OFFSETS.keys()

INVERT_DIRECTIONS = {'horizontal', 'vertical'}


class GridController(object):
    def __init__(self, client, grid_width=3, grid_height=3):
        self.client = client
        self.grid_width = grid_width
        self.grid_height = grid_height

    @property
    def target_display(self):
        return sorted(self.client.displays, key=lambda d: d.index)[0]

    @property
    def target_spaces(self):
        return self.grid_width * self.grid_height

    @property
    def current_space_coords(self):
        current_space_index = self.current_space.index0
        return (
            current_space_index // self.grid_width,
            current_space_index % self.grid_width,
        )

    @property
    def current_space(self):
        return self.client.focused_space

    def reset(self):
        current_spaces = len(self.client.spaces)
        while current_spaces != self.target_spaces:
            if current_spaces < self.target_spaces:
                self.target_display.create_space()
            elif current_spaces > self.target_spaces:
                pass
            current_spaces = len(self.client.spaces)

    def index_for_coords(self, coords):
        row, column = coords
        return row * self.grid_width + column

    def move(self, row_offset=0, column_offset=0):
        space = self.space_relative(row_offset=row_offset, column_offset=column_offset)
        space.focus()
        return space

    def move_window(self, row_offset=0, column_offset=0, follow=False):
        space = self.space_relative(row_offset=row_offset, column_offset=column_offset)
        window = self.client.focused_window
        window.send_to_space(space)
        if follow:
            space.focus()
        return window

    def space_relative(self, coords=None, row_offset=0, column_offset=0):
        row, column = coords or self.current_space_coords
        relative_coords = (
            max(0, min(self.grid_height - 1, row + row_offset)),
            max(0, min(self.grid_width - 1, column + column_offset)),
        )
        space_index = self.index_for_coords(relative_coords)

        matching_spaces = [s for s in self.client.spaces if s.data['index'] == space_index + 1]
        return matching_spaces[0] if matching_spaces else None

    def print_grid(self, tablefmt='fancy_grid'):
        highlight = lambda s: f'*{s}*'
        normal = lambda s: f'-{s}- '
        data = [
            [normal('grid1.1'), normal('grid1.2')],
            [highlight('grid2.1'), normal('grid2.2')],
        ]
        table = tabulate.tabulate(data, tablefmt=tablefmt)
        print(table)
