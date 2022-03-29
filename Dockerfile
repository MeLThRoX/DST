FROM node:alpine as solidity
WORKDIR /code
ENV PATH /code/node_modules/.bin:$PATH
COPY backend/solidity/code/* ./
RUN npm install
RUN solcjs --bin --abi --include-path node_modules --base-path . -o build dst.sol

FROM node:alpine as contract
ARG PRIVATE_KEY
ARG PROVIDER
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
ENV PRIVATE_KEY=$PRIVATE_KEY
ENV PROVIDER=$PROVIDER
COPY backend/deployer/* ./
COPY config.json ./
COPY --from=solidity /code/build/dst_sol_DST.abi /contract/abi.json
COPY --from=solidity /code/build/dst_sol_DST.bin /contract/bytecode
RUN npm install
RUN npm start

FROM node:alpine
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY /frontend /app
COPY --from=contract /app/config.json /app/src/
COPY --from=solidity /code/build/dst_sol_DST.abi /app/src/ABI.json
RUN npm install
RUN npm run build
EXPOSE 4002
EXPOSE 4003
CMD [ "npm", "run", "ipfs" ]