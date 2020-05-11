import React from 'react'
import { useViewport } from 'use-viewport'
import { useAragonApi } from '@aragon/api-react'
import {
  Box,
  Card,
  Bar,
  BackButton,
  CircleGraph,
  Distribution,
  TokenInfoBoxRow,
  Split,
  Button,
  ContextMenu,
  ContextMenuItem,
  DataView,
  GU,
  Header,
  IconUnlock,
  IconFundraising,
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
              label="Buy Tokens"
              icon={<IconFundraising />}
              display={compactMode ? 'icon' : 'all'}
              onClick={() => api.increment(1).toPromise()}
              css={`
                margin-right: ${1 * GU}px;
              `}
            />
          </>
        }
      />

      <div
        css={`
          width: ${10 * GU}px;
          padding: ${1 * GU}px ${2 * GU}px;
        `}
      />
      <Split
        primary={<DataView
          fields={['Beneficiary', 'Sold']}
          entries={[
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '50000' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '1400' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '200' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '1000' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '1500' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', rate: '3000' },
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
            <Box heading="Token info">
              <div
              css={`
                display: flex;
                justify-content: space-between;
              `}
              >
                <div
                  css={`
                    color: ${theme.surfaceContentSecondary};
                  `}
                >
                  {'Rate:'}
                </div>
                <div>{'1 : 100'}</div>
              </div>
              <div
              css={`
                display: flex;
                justify-content: space-between;
              `}
              >
                <div
                  css={`
                    color: ${theme.surfaceContentSecondary};
                  `}
                >
                  {'Hard Cap:'}
                </div>
                <div>{'1,000,000 TKN'}</div>
              </div>
              <div
              css={`
                display: flex;
                justify-content: space-between;
              `}
              >
                <div
                  css={`
                    color: ${theme.surfaceContentSecondary};
                  `}
                >
                  {'Tokens Sold:'}
                </div>
                <div>{'333,333 TKN'}</div>
              </div>
              <div
              css={`
                display: flex;
                justify-content: space-between;
              `}
              >
                <div
                  css={`
                    color: ${theme.surfaceContentSecondary};
                  `}
                >
                  {'ETH Raised:'}
                </div>
                <div>{'333 ETH'}</div>
              </div>
            </Box>
            <Box heading="Sale Metrics">
              <CircleGraph value={1/3} size={220} />
            </Box>
      </>
        }
      />
      
    </Main>
  )

  // TokenInfoBoxRow is relying on useTheme() to get a specific text color.
function TokenInfoBoxRow({ primary, secondary }) {
  const theme = useTheme()
  return (
    <div
      css={`
        display: flex;
        justify-content: space-between;
      `}
    >
      <div
        css={`
          color: ${theme.surfaceContentSecondary};
        `}
      >
        {primary}
      </div>
      <div>{secondary}</div>
    </div>
  )
}
}

export default App
