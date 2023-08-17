import type { Meta, StoryObj } from "@storybook/svelte";

import Defn from "./Defn.svelte";

const meta: Meta<Defn> = {
  title: "Defn",
  component: Defn,
  tags: ["autodocs"],
};

export default meta;

type Story = StoryObj<Defn>;

export const Primary: Story = {};
