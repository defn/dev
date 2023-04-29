import type { Meta, StoryObj } from '@storybook/svelte';

import Counter from './Counter.svelte';

const meta: Meta<Counter> = {
  title: 'Counter',
  component: Counter,
  tags: ['autodocs']
};

export default meta;

type Story = StoryObj<Counter>;

export const Primary: Story = {};
