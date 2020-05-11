import React from 'react'
import { useViewport } from 'use-viewport'
import { useAragonApi } from '@aragon/api-react'
import {
  Box,
  TokenInfoBoxRow,
  Split,
  Button,
  ContextMenu,
  ContextMenuItem,
  DataView,
  GU,
  Header,
  IconUnlock,
  IconLock,
  IconTrash,
  IdentityBadge,
  Main,
  SyncIndicator,
  Tag,
  textStyle,
  useTheme,
} from '@aragon/ui'

function App() {
  const { api, appState } = useAragonApi()

  const { count, isSyncing } = appState

  const theme = useTheme()
  const { below } = useViewport()

  const compactMode = below('medium')

  return (
    <Main>
      {isSyncing && <SyncIndicator />}
      <Header
        primary={
          <div
            css={`
              display: flex;
              justify-content: center;
              align-items: center;
            `}
          >
            <div
              css={`
                ${textStyle('title2')}
              `}
            >
              Token Sale
            </div>
            <Tag
              mode="identifier"
              label="TKN"
              css={`
                margin-left: ${1 * GU}px;
                margin-top: ${0.5 * GU}px;
              `}
            />
          </div>
        }
        secondary={
          <>
            <Button
              mode="strong"
              label="Open Sale"
              icon={<IconUnlock />}
              display={compactMode ? 'icon' : 'all'}
              onClick={() => api.increment(1).toPromise()}
              css={`
                margin-right: ${1 * GU}px;
              `}
            />
            <Button
              mode="strong"
              label="Close Sale"
              icon={<IconLock />}
              onClick={() => api.decrement(1).toPromise()}
              display={compactMode ? 'icon' : 'all'}
            />
          </>
        }
      />
      <Split
        primary={<DataView
          fields={['Beneficiary', 'Sold']}
          entries={[
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '50000' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '1400' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '20' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '1000' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '1500' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '1' },
          ]}
          renderEntry={({ account, rate }) => {
            return [
              <IdentityBadge entity={account} />,
              <div
                css={`
                  ${textStyle('body2')}
                `}
              >
                {rate}
              </div>,
            ]
          }}
        />}
        secondary={
          <>
            <Box heading="Sale Metrics">
            </Box>
          </>
        }
      />
      
    </Main>
  )
}

export default App
