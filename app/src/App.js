import React, { useState } from 'react'
import { Main, Tag, Header, Button, IconPlus, SidePanel, Split, Card, Box } from '@aragon/ui'

import TokenHoldersView from './TokenHoldersView'
import TokenInfoBox from './TokenInfoBox'


// Some demo data
const token = {
  name: 'My Organization Token',
  symbol: 'MOT',
  address: '0x…',
  transferable: true,
  supply: 8,
  holders: [
    ['0xcafe…', 3],
    ['0xbeef…', 2],
    ['0xfeed…', 1],
    ['0xface…', 1],
    ['0xbead…', 1],
  ],
}

function App() {
  const [sidePanelOpened, setSidePanelOpened] = useState(false)
  return (
    <Main>
      <Header
        primary={
          <>
            Token Sale
            <Tag mode="identifier">TKN</Tag>
          </>
        }
        secondary={
          <Button
            mode="strong"
            label="Buy Tokens"
            icon={<IconPlus />}
            onClick={() => setSidePanelOpened(true)}
          />
        }
      />
      <SidePanel
        title="Buy Tokens"
        opened={sidePanelOpened}
        onClose={() => setSidePanelOpened(false)}
      >
        {/* SidePanel content goes here */}
      </SidePanel>
    </Main>
  )
}
export default App
