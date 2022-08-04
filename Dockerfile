FROM swift:latest as builder
WORKDIR /root
COPY ./Package.* ./
RUN swift package resolve
COPY . .
RUN swift build -c release

FROM swift:slim
COPY --from=builder /root/.build build
CMD ["build/release/PioneerChatExample"]