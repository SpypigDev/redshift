import { classes } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Divider, Section, Stack } from '../components';
import { Window } from '../layouts';

type AnomalyAIPreset = {
  name: string;
  path: string;
  description: string;
  type: string;
  requires_spawn_config: boolean;
  icon: string;
};

type BackendContext = {
  presets: { [key: string]: AnomalyAIPreset[] };
};

export const AnomalyAISpawner = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const [chosenPreset, setPreset] = useState<AnomalyAIPreset | null>(null);
  const { presets } = data;
  return (
    <Window title="Human AI Spawner" width={450} height={300}>
      <Window.Content className="AnomalySpawner__Background">
        <Box className="AnomalySpawner__Casing">
          <Box className="AnomalySpawner__Gradient" width="100%" height="100%">
            <Box className="AnomalySpawner__Static" width="100%" height="100%">
              <Box
                className="AnomalySpawner__Screen"
                width="100%"
                height="100%"
              >
                <AnomalyAISpawnerr />
              </Box>
            </Box>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};

const AnomalyAISpawnerr = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const [chosenPreset, setPreset] = useState<AnomalyAIPreset | null>(null);
  const { presets } = data;
  return (
    <Section fill className="AnomalySpawner__Main">
      <Stack fill>
        <Stack.Item grow mr={1}>
          <Section fill scrollable>
            {Object.keys(presets).map((dictKey) => (
              <Stack key={dictKey} vertical>
                <Stack.Item className="AnomalyClass" fontSize={1.1} bold>
                  &gt;&gt;&gt; {dictKey} Class Hazard
                </Stack.Item>
                {presets[dictKey].map((squad) => (
                  <Stack.Item pb={'12px'} key={squad.path}>
                    <Button
                      className="AnomalyType"
                      selected={squad === chosenPreset}
                      key={squad.path}
                      onClick={() => setPreset(squad)}
                    >
                      - {squad.name} -
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
            ))}
          </Section>
        </Stack.Item>
        <Divider vertical />
        <Stack.Item width="40%">
          <Stack height="100%" vertical>
            <Stack.Item
              className="AnomalyClass"
              fontSize={1.1}
              bold
              textAlign="center"
              pb="3px"
            >
              Selected Preset
            </Stack.Item>
            <Stack.Item
              className="SelectedPreset"
              fontSize={1.2}
              bold
              textAlign="center"
              mt="3px"
            >
              {chosenPreset ? chosenPreset.name : 'NONE'}
            </Stack.Item>
            <Stack fill pt="5%">
              <Stack.Item width="50%">
                <Box align="left" ml="-30%">
                  <span
                    className={classes([
                      'anomaly_menu128x128',
                      `${chosenPreset ? chosenPreset.icon : 'ss13'}`,
                    ])}
                  />
                </Box>
              </Stack.Item>
              <Stack.Item className="AnomalyInfo" height="90%">
                {chosenPreset ? chosenPreset.description : ''}
              </Stack.Item>
            </Stack>
            <Button
              textAlign="center"
              className="AnomalySpawner__SpawnButton"
              fontSize={1.1}
              bold
              width="100%"
              onClick={() =>
                act('create_ai', {
                  path: chosenPreset && chosenPreset.path,
                })
              }
            >
              - SPAWN ENTITY -
            </Button>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
