import type { Meta, StoryObj } from '@storybook/svelte';

import Page from './Page.svelte';

const meta: Meta<Page> = {
  title: 'Page',
  component: Page,
  tags: ['autodocs']
};

export default meta;

type Story = StoryObj<Page>;

export const Primary: Story = {};
