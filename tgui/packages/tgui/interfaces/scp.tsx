import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

export const scp = (props) => {
  const { act, data } = useBackend();
  // Extract `health` and `color` variables from the `data` object.
  return (
    <Window width={400} height={600} theme="scp">
      <Window.Content>
        <Section fitted backgroundColor="hsla(323, 7%, 23%, 1.00)">
          <Section>
            <div>
              <Button onClick={() => 1} icon="1" />
              <Button onClick={() => 1} icon="2" />
              <Button onClick={() => 1} icon="3" />
              <Button onClick={() => 1} icon="4" />
              <Button onClick={() => 1} icon="5" />
              <Button onClick={() => 1} icon="6" />
              <Button onClick={() => 1} icon="7" />
              <Button onClick={() => 1} icon="8" />
              <Button onClick={() => 1} icon="9" />
              <Button onClick={() => 1} icon="0" />
            </div>
            <div>
              <Button onClick={() => 1} icon="q" />
              <Button onClick={() => 1} icon="w" />
              <Button onClick={() => 1} icon="e" />
              <Button onClick={() => 1} icon="r" />
              <Button onClick={() => 1} icon="t" />
              <Button onClick={() => 1} icon="y" />
              <Button onClick={() => 1} icon="u" />
              <Button onClick={() => 1} icon="i" />
              <Button onClick={() => 1} icon="o" />
              <Button onClick={() => 1} icon="p" />
            </div>
            <div>
              <Button onClick={() => 1} icon="a" />
              <Button onClick={() => 1} icon="s" />
              <Button onClick={() => 1} icon="d" />
              <Button onClick={() => 1} icon="f" />
              <Button onClick={() => 1} icon="g" />
              <Button onClick={() => 1} icon="h" />
              <Button onClick={() => 1} icon="j" />
              <Button onClick={() => 1} icon="k" />
              <Button onClick={() => 1} icon="l" />
              <Button onClick={() => 1} icon="check" />
            </div>
            <div>
              <Button onClick={() => 1} icon="z" />
              <Button onClick={() => 1} icon="x" />
              <Button onClick={() => 1} icon="c" />
              <Button onClick={() => 1} icon="v" />
              <Button onClick={() => 1} icon="b" />
              <Button onClick={() => 1} icon="n" />
              <Button onClick={() => 1} icon="m" />
              <Button onClick={() => 1} icon="minus" />
              <Button onClick={() => 1} icon="far_square" />
              <Button onClick={() => 1} icon="arrow-left" />
            </div>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
